class MatchesController < ApplicationController
  def index
    @current_stage = params[:stage] || "1"
    @cup = Cup.first
    @matches = @cup.matches.stage(@current_stage)
    @stages = Stage.all
  end
end
