Tippspiel::Application.routes.draw do
  devise_for :users

  get "public/index"

  scope :defaults => { cup_id: "euro-2012" } do
    #resources :matches, only: [:index, :show, :edit, :update],
    #                    path_names: { edit: 'result' }
    #resources :group_matches, only: [:index, :show, :edit, :update],
    #                          path_names: { edit: 'result' },
    #                          controller: :matches
    #resources :playoff_matches, only: [:index, :show, :edit, :update],
    #                            path_names: { edit: 'result' },
    #                            controller: :matches

    get ":stage_id", to: "stages#show", as: :play_off, constraints: { stage_id: /viertelfinale|halbfinale|finale|quarterfinal|semifinal|final/ }
    put ":stage_id", to: "stages#update", constraints: { stage_id: /viertelfinale|halbfinale|finale|quarterfinal|semifinal|final/ }
    scope ":stage_id", as: :play_off, constraints: { stage_id: /viertelfinale|halbfinale|quarterfinal|semifinal/ } do
      get ":id", as: :match,
                 to: "matches#show",
                 constraints: { id: /\d+/ }
      put ":id", as: :match,
                 to: "matches#update",
                 constraints: { id: /\d+/ }
    end
    resources :groups, constraints: { id: /[a-d]/ },
                       only: [:show, :update, :index],
                       path: :gruppen,
                       controller: :stages do
        resources :matches, constraints: { id: /\d+/ },
                            only: [:show, :edit, :update],
                            path_name: { edit: 'eintragen' },
                            path: ""
    end
    
    root to: "cups#show"
  end

end
