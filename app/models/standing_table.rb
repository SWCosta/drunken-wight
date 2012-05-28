class StandingTable < ActiveRecord::Base
  belongs_to :standing
  belongs_to :team

  before_validation :set_country_name_if_changed

  private

  def set_country_name_if_changed
    self.team_name = Team.find(team_id).country if team_id_changed?
  end
end
