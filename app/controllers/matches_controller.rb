class MatchesController < ApplicationController
  def index
    stage_id = params[:stage] || "1"
    @cup = Cup.first
    @matches = @cup.matches.stage(stage_id)
  end
end
