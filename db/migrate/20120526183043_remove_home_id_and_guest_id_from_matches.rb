class RemoveHomeIdAndGuestIdFromMatches < ActiveRecord::Migration
  def up
    remove_column :matches, :home_id
    remove_column :matches, :guest_id
  end

  def down
    add_column :matches, :guest_id, :integer
    add_column :matches, :home_id, :integer
  end
end
