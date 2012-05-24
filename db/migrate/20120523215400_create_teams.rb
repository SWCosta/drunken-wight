class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :country
      t.references :stage

      t.timestamps
    end
  end
end
