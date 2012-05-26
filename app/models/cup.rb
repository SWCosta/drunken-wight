class Cup < ActiveRecord::Base
  has_many :matches, :include => [:home,:guest]
  has_many :stages, through: :matches

  def standings
    Standing.all
  end

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
