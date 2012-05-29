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
    @stage_matches = stage_matches
    @match = current_match
  end

  def update
    debugger
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
    else
      view_context.show_match_caster(@match)
    end
  end

  def stage_matches
    @stage_matches ||= (current_stage && current_stage.matches)
  end

  def current_match
    @match ||= (current_stage.matches.find(params[:id]) rescue nil)
  end

end
