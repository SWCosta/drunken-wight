class Match < ActiveRecord::Base
  belongs_to :cup
  belongs_to :stage
end
