class Group < ActiveRecord::Base
  IDS = Group.all.map(&:id)

  belongs_to :stage
  has_many :teams
  has_many :matches, through: :teams,
                     uniq: true

  composed_of :standing, mapping: [%w(id group)],
                         constructor: proc { |a| Standing.new({:group_id => a}) }

end
