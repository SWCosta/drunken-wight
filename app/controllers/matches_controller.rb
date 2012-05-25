class MatchesController < ApplicationController
  before_filter do
    @cup = Cup.first
    @stages = Stage.all
  end

  helper_method :current_stage, :current_match

  def index
    stage_id = current_stage.is_a?(Stage) ? current_stage.id : nil
    @matches = @cup.matches.stage(stage_id)
    @standings = current_stage.standings
  rescue ArgumentError
  end

  def show
    @stage_matches = current_match.stage.matches
  end

  def edit
    @stage_matches = current_match.stage.matches
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

  def current_stage
    @current_stage ||= (Stage.find(params[:stage]) rescue @cup)
  end

  def current_match
    @match ||= (Match.find(params[:id]) rescue nil)
  end
end
