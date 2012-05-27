class Cup < ActiveRecord::Base
  has_many :matches, include: :teams
  has_many :stages, through: :matches
  has_many :teams, through: :matches

  composed_of :standing, mapping: [%w(id cup)],
                         constructor: proc { |a| Standing.new( cup_id: a ) }

  # yields [group, position] to play quarterfinal x as y
  def quarterfinal_mapping(x,y)
    y = { home: 0, guest: 1 }[y] if y.is_a? Symbol
    # HAIL TO THE MOD
    [x - x%2 + (x+y)%2, y]
  end

  # the winner of this n-th ancestors will play
  def finals_mapping(id, role)
    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
    1 + id + 2*role 
  end

end
