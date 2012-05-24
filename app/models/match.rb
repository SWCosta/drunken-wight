class Match < ActiveRecord::Base
  belongs_to :cup
  belongs_to :stage
  belongs_to :home, class_name: "Team"
  belongs_to :guest, class_name: "Team"

  has_many :bets
  has_many :users, through: :bets

  scope :stage, lambda{ |id| where(:stage_id => id) }
end
