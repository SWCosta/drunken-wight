class MatchesController < CupsController
  before_filter :load_cup_data, :set_stage_id

  helper_method :current_stage, :current_match

  def index
    @matches = current_stage.matches.unscoped.order(:date)
    @standings = current_stage.results.order(:rank) rescue nil
  end

  def show
    #@stage_matches = current_match.stage.matches
    @match = Match.find(params[:id])
  end

  def edit
    #@stage_matches = current_match.stage.matches
    @match = Match.find(params[:id])
  end

  def update
    @match = current_match
    if @match.update_attributes(params[:match])
      redirect_to @match, notice: "Erfolgreich aktualisiert"
    else
      render :edit
    end
  end

  private

#  def current_stage
#    @current_stage ||= (Stage.find(params[:stage_id]) rescue @cup)
#  end
#
#  def current_match
#    @match ||= (current_stage.matches.find(params[:id]) rescue nil)
#  end

  #def sanatize_params_bla
  #  if params
  #    debugger
  #    (res = (params.find{ |k,v| k.to_s =~ /match/ }) ? (params[res[0].sub(/[group_|playoff_]/,"")] = res[1]) : nil)
  #  end
  #  #if params
  #  #  params = Hash[ params.map do |k,v| [
  #  #    (k =~ /match/) ? k : k.sub(/.*match/,"match"),
  #  #    v
  #  #  ]end]
  #  #end
  #end

end
