class Group < ActiveRecord::Base
  belongs_to :stage
  has_many :teams
  has_many :matches, through: :teams,
                     uniq: true
end
