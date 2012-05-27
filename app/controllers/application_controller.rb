class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private

  def load_cup_data
    @cup = Cup.first
    @stages = @cup.stages.uniq!
  end
end
