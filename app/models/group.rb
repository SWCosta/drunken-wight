class Group < Stage
  IDS = Group.all.map(&:id)

  delegate :update_results, to: :standing

  has_many :teams
  has_one :standing, as: :rateable,
                     readonly: true
  has_many :results, through: :standing,
                     readonly: true

  #TODO: make this better
  def has_finished?
    results.map(&:matches).map(&:to_i).min == (teams.count - 1)
  end

  # checks if there is is a definite winner of a group
#  def has_a?(position)
#    if self.is_a_group?
#      return true if matches.where(home_score: nil).blank?
#      no = { winner: 0, runner_up: 1 }[position]
#      points = standings.map(&:overall_points).map(&:to_i)
#      points[no] - points[no+1] > 3
#    else
#      false
#    end
#  end

#  def get_the position
#    if self.is_a_group?
#      no = { winner: 0, runner_up: 1, third: 2, last: 3 }[position]
#      Team.find(standings[no].team_id)
#    end
#  end
#
#  def is_a_group?
#    id.in? GROUPS
#  end

#  def to_params
#    name.match(/\w$/)[0].upcase
#  end
end
