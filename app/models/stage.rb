class Stage < ActiveRecord::Base
  WITH_STANDINGS = Stage.where("name LIKE 'Group%'").map(&:id)

  has_many :matches
  has_many :teams
  has_one :cup, through: :matches

  def standings(*args)
    options = args.extract_options!
    options[:stage_id] = self.id
    Standing.new(options).results
  end
end
