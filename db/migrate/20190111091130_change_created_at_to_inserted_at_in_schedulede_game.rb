class ChangeCreatedAtToInsertedAtInScheduledeGame < ActiveRecord::Migration[5.2]
  def change
    rename_column :scheduled_games, :created_at, :inserted_at
  end
end
