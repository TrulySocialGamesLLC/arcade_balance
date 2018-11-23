class AddChallengesTables < ActiveRecord::Migration[5.2]
  def change

    create_table :challenges do |t|
      t.json    :extra
      t.integer :day_duration
      t.integer :week_duration
      t.integer :minimum_daily_score
      t.integer :utc_offset_seconds
    end

    create_table :milestones do |t|
      t.string  :name
      t.json    :rewards
      t.integer :range_offset_percent
      t.integer :challenge_id
    end

  end
end
