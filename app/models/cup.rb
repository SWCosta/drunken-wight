class Cup < ActiveRecord::Base
  has_many :matches, :include => [:home,:guest]
  has_many :stages, through: :matches

  def standings
    Standing.all
  end
end
