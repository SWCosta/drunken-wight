class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :name
      t.string :type
      t.string :slug, null: false
      t.references :cup

      t.timestamps
    end
    add_index :stages, :cup_id
    add_index :stages, :slug
  end
end
