class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :cup
      t.string :type
      t.references :stage
      t.references :home
      t.references :guest
      t.integer :home_score
      t.integer :guest_score
      t.references :following

      t.datetime :date

      t.timestamps
    end
    add_index :matches, :cup_id
    add_index :matches, :stage_id
  end
end
