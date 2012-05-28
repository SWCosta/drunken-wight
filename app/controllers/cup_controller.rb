class CupController < ApplicationController
  before_filter :load_cup_data

  private

  def load_cup_data
    @cup = Cup.find(params[:cup_id])
    @stages = @cup.stages.order :id
  end
end
