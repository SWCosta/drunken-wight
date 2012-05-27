class StandingRow
  attr_accessor :team_id, :shot, :got, :diff, :points, :matches

  def initialize(team_id, shot, got, diff, points, matches)
    @team_id = team_id
    @shot = shot
    @got = got
    @diff = diff
    @points =  points
    @matches = matches
  end

  def team
    Team.find(team_id)
  end
end
