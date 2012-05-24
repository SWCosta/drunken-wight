class Team < ActiveRecord::Base
  belongs_to :stage

  #has_many :matches, finder_sql: "SELECT * FROM matches WHERE matches.home_id=? OR matches.guest_id=?, #{self.id}, #{self.id}"
end
