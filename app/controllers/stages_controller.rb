class StagesController < CupsController
  before_filter :set_stage_id

  def index
    render text: params.to_yaml
  end

  def show
#    @stage = Stage.find(params[:stage_id])
#    @matches = @stage.matches.reorder(:date)
#    @standings = @stage.results.order(:rank) rescue nil
    render text: params.to_yaml
  end
end
