class CreateMatchParticipations < ActiveRecord::Migration
  def change
    create_table :match_participations do |t|
      t.references :match
      t.references :team
      t.integer :role

      t.timestamps
    end
    add_index :match_participations, :match_id
    add_index :match_participations, :team_id
  end
end
