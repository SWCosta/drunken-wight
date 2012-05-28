class CupsController < ApplicationController
  before_filter :load_cup_data, :handle_sti

  helper_method :current_stage

  def show
    @matches = @cup.matches.unscoped.order(:date)
    @standings = @cup.results.order(:rank) rescue nil
  end

  private

  def current_stage
    nil
  end

  def set_stage_id
#    params[:stage_id] = { "gruppen" => "groups",
#                          "viertelfinale" => "quarterfinal",
#                          "halbfinale" => "semifinal",
#                          "finale" => "final" }[params[:stage_id]]
    params[:stage_id] ||= params[:group_id]
    params[:stage_id] ||= params[:id]
  end

  def load_cup_data
    @cup = Cup.find(params[:cup_id])
    @stages = @cup.stages.order :id
  end

  def handle_sti
    params[:stage_id] ||= params[:group_id] || params[:play_off_id]
  end
end
