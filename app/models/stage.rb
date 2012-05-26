class Stage < ActiveRecord::Base
  GROUPS = Stage.where("name LIKE 'Group%'").map(&:id)
  PLAY_OFFS = Stage.where("name NOT LIKE 'Group%'").map(&:id)

  has_many :matches
  #has_many :teams #TODO: check is that is used
  has_one :cup, through: :matches

  def standings(*args)
    if self.is_a_group?
      options = args.extract_options!
      options[:stage_id] = self.id
      Standing.new(options).results
    else
      nil
    end
  end

  # checks if there is is a definite winner of a group
  def has_a?(position)
    if self.is_a_group?
      return true if matches.where(home_score: nil).blank?
      no = { winner: 0, runner_up: 1 }[position]
      points = standings.map(&:overall_points).map(&:to_i)
      points[no] - points[no+1] > 3
    else
      false
    end
  end

  def get_the position
    if self.is_a_group?
      no = { winner: 0, runner_up: 1, third: 2, last: 3 }[position]
      Team.find(standings[no].team_id)
    end
  end

  def is_a_group?
    id.in? GROUPS
  end
end
