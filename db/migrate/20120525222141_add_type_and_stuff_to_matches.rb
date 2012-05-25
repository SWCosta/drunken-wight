class AddTypeAndStuffToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :type, :string
    add_column :matches, :following_id, :integer
  end
end
