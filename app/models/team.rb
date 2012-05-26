class Team < ActiveRecord::Base
  belongs_to :stage
  belongs_to :group

  has_many :match_participations
  has_many :matches, through: :match_participations do
    def as_home
      where( match_participations: { role: 0 } )
    end
    def as_guest
      where( match_participations: { role: 1 } )
    end
  end
end
