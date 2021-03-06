class MatchesController < CupsController
  before_filter :load_cup_data, :set_stage_id

  helper_method :current_stage, :current_match

  def index
    @matches = current_stage.matches.unscoped.order(:date)
    @standings = current_stage.results.order(:rank) rescue nil
  end

  def show
    @stage_matches = stage_matches
    @match = current_match
  end

  def edit
    @match = current_match
    respond_to do |format|
      format.html { @stage_matches = stage_matches }
      format.js {}
    end
  end

  def update
    @match = current_match
    if @match.update_attributes(params[:match])
      redirect_to redirect_path(@match), notice: "Erfolgreich aktualisiert"
    else
      render :edit
    end
  end

  private

  def redirect_path(match=nil)
    if request.path =~ /^\/spiele/
      root_path
    elsif @match.is_a? GroupMatch
      view_context.group_path(params[:group_id])
    else
      view_context.play_off_path(params[:stage_id])
    end
  end

  def stage_matches
    @stage_matches ||= (current_stage && current_stage.matches)
  end

  def current_match
    @match ||= (current_stage.matches.find(params[:id]) rescue nil)
  end

end
