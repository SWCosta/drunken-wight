Tippspiel::Application.routes.draw do
  devise_for :users

  get "public/index"

  scope :defaults => { cup_id: "euro-2012" } do

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
    get "finale/eintragen", to: "matches#edit", defaults: { stage_id: "finale", id: 1 }, as: :edit_final_match
    scope ":stage_id", as: :edit_play_off, constraints: { stage_id: /viertelfinale|halbfinale|quarterfinal|semifinal|finale|final/ } do
      get ":id/eintragen", as: :match,
                           to: "matches#edit",
                           constraints: { id: /\d+/ }
    end
    resources :groups, constraints: { id: /[a-d]/ },
                       only: [:show, :update, :index],
                       path: :gruppen,
                       controller: :stages do
        resources :matches, constraints: { id: /\d+/ },
                            only: [:show, :update, :edit],
                            path_names: { edit: 'eintragen' },
                            path: ""
        #get ":id/eintragen", to: "matches#edit",
        #                     constraints: { id: /\d+/ }

    end

    resources :matches, only: [:edit, :update],
                        path: :spiele,
                        path_names: { edit: 'eintragen' },
                        constraints: { id: /\d+/ }
    
    root to: "cups#show"
  end

end
