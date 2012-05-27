class Match < ActiveRecord::Base
  belongs_to :cup
  belongs_to :stage
  has_many :match_participations
  has_many :teams, through: :match_participations
  has_one :home_participation, class_name: "MatchParticipation",
                               conditions: { role: 0 }
  has_one :home, through: :home_participation,
                 source: :team
  has_one :guest_participation, class_name: "MatchParticipation",
                                conditions: { role: 1 }
  has_one :guest, through: :guest_participation,
                  source: :team

  has_many :bets
  has_many :users, through: :bets

  # should that be in MatchParticipation ?
  composed_of :result, mapping: [%w(home_score home), %w(guest_score guest)]

  validates :home_score, numericality: { only_integer: true,
                                         allow_nil: true,
                                         greater_than_or_equal_to: 0 }
  validates :guest_score, numericality: { only_integer: true,
                                          allow_nil: true,
                                          greater_than_or_equal_to: 0 }
  validates_presence_of :stage_id, :cup_id, :date

  default_scope order(:date)

  scope :with_result, lambda{ |home,guest| with_result_query(home,guest) }

  # get all results with 3:2 or 2:3 e.g.
  def self.with_result_query(home,guest)
    where("(matches.home_score = :home AND matches.guest_score = :guest) OR \
           (matches.home_score = :guest AND matches.guest_score = :home)", 
           :home => home, :guest => guest)
  end

  # so you can call Stage.first.standings.first.team
  def team
    home
  end

  # returns a Team or nil
  def winner
    choose_team_from_comparison(result.toto)
  end

  # returns a Team or nil
  def loser
    choose_team_from_comparison(-result.toto)
  end

  private

  def choose_team_from_comparison(int)
    int == 1 ? home : ( int == -1 ? guest : nil ) rescue nil
  end
end
