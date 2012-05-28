class Stage < ActiveRecord::Base
  belongs_to :cup
  has_many :matches

  validates_presence_of :cup_id
end
