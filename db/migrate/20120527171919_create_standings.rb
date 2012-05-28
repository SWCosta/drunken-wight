class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.references :rateable, polymorphic: true

      t.timestamps
    end

    add_index :standings, [:rateable_id,:rateable_type]
  end
end
