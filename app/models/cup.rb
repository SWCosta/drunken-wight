class Cup < ActiveRecord::Base
  has_many :matches
  has_many :stages, through: :matches
end
