class Stage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :cup

  belongs_to :cup


  has_many :matches, include: [:match_participations, :home, :guest]

  validates_presence_of :cup_id

  def translated
    output = { "quarterfinal" => "viertelfinale",
      "semifinal" => "halbfinale",
      "final" => "finale" }[slug]
    output || slug
  end
end
