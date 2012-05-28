class StandingTable < ActiveRecord::Base
  belongs_to :standing
  belongs_to :team
end
