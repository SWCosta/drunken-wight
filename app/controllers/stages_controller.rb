class StagesController < CupsController
  before_filter :set_stage_id

  def index
    render text: "it works"
  end

  def show
    @stage = Stage.find(params[:stage_id])
    @matches = @stage.matches
#    foobar = play_off_path(Stage.last)
#    #render text: params.to_yaml.<<(foobar)
#    sf = Stage.find_by_id(6)
#    pa = Match.find_by_id(30)
#    redirect_to sf, pa
  end
end
