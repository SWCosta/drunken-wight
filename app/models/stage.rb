class Stage < ActiveRecord::Base
  GROUPS = Stage.where("name LIKE 'Group%'").map(&:id)
  PLAY_OFFS = Stage.where("name NOT LIKE 'Group%'").map(&:id)

  has_many :matches
  has_many :teams
  has_one :cup, through: :matches

  def standings(*args)
    if id.in? GROUPS
      options = args.extract_options!
      options[:stage_id] = self.id
      Standing.new(options).results
    else
      nil
    end
  end
end
