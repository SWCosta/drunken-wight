class Match < ActiveRecord::Base
  belongs_to :stage
  has_many :match_participations, dependent: :destroy
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
  validates_presence_of :stage_id, :date

  default_scope order(:date)

  # this can be really expensive
  after_save :update_all_results, :set_participants

  scope :with_result, lambda{ |home,guest| with_result_query(home,guest) }

  # get all results with 3:2 or 2:3 e.g.
  def self.with_result_query(home,guest)
    where("(matches.home_score = :home AND matches.guest_score = :guest) OR \
           (matches.home_score = :guest AND matches.guest_score = :home)", 
           :home => home, :guest => guest)
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

  def update_all_results
    if home_score_changed? || guest_score_changed?
      stage.update_results
      stage.cup.update_results
    end
  end

  def set_participants
    Match.all.each do |match|
      if !match.home && match.participant(:home).is_a?(Team)
        #set home
        match.home = match.participant(:home)
        match.save!
      end
      if !match.guest && match.participant(:guest).is_a?(Team)
        #set guest
        match.guest = match.participant(:guest)
        match.save!
      end
    end
  end
end
