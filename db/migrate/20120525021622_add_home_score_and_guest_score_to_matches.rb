class AddHomeScoreAndGuestScoreToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :home_score, :integer
    add_column :matches, :guest_score, :integer
  end
end
