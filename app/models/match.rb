class Match < ActiveRecord::Base
  belongs_to :cup
  belongs_to :stage
  belongs_to :home, class_name: "Team"
  belongs_to :guest, class_name: "Team"

  has_many :bets
  has_many :users, through: :bets

  composed_of :result, mapping: [%w(home_score home), %w(guest_score guest)]

  validates :home_score, numericality: { only_integer: true,
                                         allow_nil: true,
                                         greater_than_or_equal_to: 0 }
  validates :guest_score, numericality: { only_integer: true,
                                          allow_nil: true,
                                          greater_than_or_equal_to: 0 }

  default_scope order(:id)

  scope :stage, lambda{ |id| id.present? ? where(:stage_id => id) : scoped }
  scope :with_result, lambda{ |home,guest| with_result_query(home,guest) }

  def self.with_result_query(home,guest)
    where("(matches.home_score = :home AND matches.guest_score = :guest) OR \
           (matches.home_score = :guest AND matches.guest_score = :home)", 
           :home => home, :guest => guest)
  end

  # so you can call Stage.first.standings.first.team
  def team
    home
  end

  def winner
    choose_team_from_comparison(result.toto)
  end

  def loser
    choose_team_from_comparison(-result.toto)
  end

  private

  def choose_team_from_comparison(int)
    int == 1 ? home : ( int == -1 ? guest : nil )
  end
end
