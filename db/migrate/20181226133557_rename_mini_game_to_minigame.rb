class RenameMiniGameToMinigame < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :mini_games, :minigames
  end

  def self.down
    rename_table :minigames, :mini_games
  end
end
