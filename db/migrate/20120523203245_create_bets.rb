class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.references :user
      t.references :match

      t.timestamps
    end
  end
end
