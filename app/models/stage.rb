class Stage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: :scoped, scope: :cup

  belongs_to :cup

  default_scope order(:id)

  has_many :matches, include: [:match_participations, :home, :guest]

  validates_presence_of :cup_id

  def slug
    key = name.parameterize
    { "quarterfinal" => "viertelfinale",
      "semifinal" => "halbfinale",
      "final" => "finale" }[key] || key
  end
end
