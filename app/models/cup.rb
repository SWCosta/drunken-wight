class Cup < ActiveRecord::Base
  has_many :matches
  has_many :stages, through: :matches
  has_many :teams, through: :matches
  has_one :standing, as: :rateable

#  composed_of :standings, mapping: [%w(id cup)],
#                          class_name: "Standing",
#                          constructor: proc { |a| Standing.new( cup_id: a ) }

  # yields [group, position] to play quarterfinal x as y
  def quarterfinal_mapping(x,y)
    y = { home: 0, guest: 1 }[y] if y.is_a? Symbol
    # HAIL TO THE MOD
    [x - x%2 + (x+y)%2, y]
  end

  # the winner of this n-th ancestors will play
  # doesn't work if there'd be a round of 16
  def finals_mapping(id, role, match_count)
    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
    id + match_count*role 
  end

end
