class Stage < ActiveRecord::Base
  has_many :matches
  # finding a way to cup
  has_one :match_example, conditions: "",
                          class_name: "Match"
  has_one :cup, through: :match_example
end
