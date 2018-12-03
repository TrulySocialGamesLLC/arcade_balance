class CreateTableBoosters < ActiveRecord::Migration[5.2]
  def change
    create_table :boosters do |t|
      t.string :name
      t.string :minigame_key
      t.integer :tier
      t.boolean :enabled

      t.belongs_to :configuration, index: true, null: false
    end
  end
end
