class CreateScheduledGames < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_games do |t|
      t.references :minigame, foreign_key: { on_delete: :cascade }
      t.date :scheduled_date

      t.timestamps
    end

    add_index :scheduled_games, [:minigame_id, :scheduled_date], unique: true
  end
end
