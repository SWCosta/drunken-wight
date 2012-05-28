class CreateCups < ActiveRecord::Migration
  def change
    create_table :cups do |t|
      t.string :name
      t.string :slug, null: false

      t.timestamps
    end
    add_index :cups, :slug, unique: true
  end
end
