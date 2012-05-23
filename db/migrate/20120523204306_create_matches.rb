class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :cup
      t.references :stage

      t.timestamps
    end
    add_index :matches, :cup_id
    add_index :matches, :stage_id
  end
end
