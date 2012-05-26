class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :stage

      t.timestamps
    end
    add_index :groups, :stage_id
  end
end
