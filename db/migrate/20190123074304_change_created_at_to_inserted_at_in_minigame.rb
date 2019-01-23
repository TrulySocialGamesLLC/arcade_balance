class ChangeCreatedAtToInsertedAtInMinigame < ActiveRecord::Migration[5.2]
  def change
    rename_column :minigames, :created_at, :inserted_at
  end
end
