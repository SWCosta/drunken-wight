class Stage < ActiveRecord::Base
  has_many :matches
  has_one :cup, through: :matches
end
