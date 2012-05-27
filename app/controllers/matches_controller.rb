class MatchesController < ApplicationController
  before_filter :load_cup_data

  helper_method :current_stage, :current_match

  def index
    @matches = current_stage.matches
    @standings = current_stage.standings
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
