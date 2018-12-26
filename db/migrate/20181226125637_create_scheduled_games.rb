class CreateScheduledGames < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_games do |t|
      t.references :mini_game, foreign_key: true
      t.datetime :scheduled_date

      t.timestamps
    end

    add_index :scheduled_games, [:mini_game_id, :scheduled_date], unique: true
  end
end
