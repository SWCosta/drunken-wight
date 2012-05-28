class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :name
      t.string :type
      t.references :cup

      t.timestamps
    end
    add_index :stages, :cup_id
  end
end
