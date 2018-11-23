class AddChallengesTables < ActiveRecord::Migration[5.2]
  def change

    create_table :challenges do |t|
      t.json    :extra

      t.timestamps
    end

    create_table :milestones do |t|
      t.string  :name
      t.json    :rewards
      t.integer :range_offset_percent

      t.references :challenge, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

  end
end
