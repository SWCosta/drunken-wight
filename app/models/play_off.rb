class PlayOff < Match
  belongs_to :following, class_name: "PlayOff"
  has_many :parents, foreign_key: :following_id,
                     class_name: "PlayOff"
end
