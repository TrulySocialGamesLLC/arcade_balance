class AddMiniGame < ActiveRecord::Migration[5.2]
  def change
    create_table :mini_games do |t|
      t.string :key, index: { unique: true }
      t.string :name
      t.text :description
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
