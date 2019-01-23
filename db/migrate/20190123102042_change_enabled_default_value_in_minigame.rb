class ChangeEnabledDefaultValueInMinigame < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:minigames, :enabled, false)
  end

  def down
    change_column_default(:minigames, :enabled, true)
  end
end
