class AddChallengesTables < ActiveRecord::Migration[5.2]
  def change

    create_table :challenges do |t|
      t.json    :extra
    end

    create_table :milestones do |t|
      t.string  :name
      t.json    :rewards
      t.integer :range_offset_percent

      t.references :challenge, foreign_key: true
    end

  end
end
