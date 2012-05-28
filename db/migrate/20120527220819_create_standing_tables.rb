class CreateStandingTables < ActiveRecord::Migration
  def change
    create_table :standing_tables do |t|
      t.references :standing
      t.integer :rank
      t.references :team
      t.string :team_name
      t.integer :shot
      t.integer :got
      t.integer :diff
      t.integer :points
      t.integer :matches

      t.timestamps
    end
    add_index :standing_tables, :team_id
  end
end
