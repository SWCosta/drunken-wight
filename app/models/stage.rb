class Stage < ActiveRecord::Base
  has_many :matches
  #has_many :teams #TODO: check is that is used
  has_one :cup, through: :matches
end
