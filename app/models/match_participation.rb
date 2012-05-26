class MatchParticipation < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
end
