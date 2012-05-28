class Stage < ActiveRecord::Base
  belongs_to :cup
  has_many :matches, include: [:match_participations, :home, :guest]

  validates_presence_of :cup_id
end
