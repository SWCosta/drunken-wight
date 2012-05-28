class StagesController < CupsController
  before_filter :set_stage_id

  def index
    render text: "it works"
  end

  def show
    @stage = Stage.find(params[:stage_id])
    @matches = @stage.matches.reorder(:date)
    @standings = @stage.results.order(:rank) rescue nil
  end
end
