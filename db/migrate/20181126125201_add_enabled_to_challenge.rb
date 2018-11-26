class AddEnabledToChallenge < ActiveRecord::Migration[5.2]
  def change
    change_table :challenges do |t|
      t.boolean :enabled, default: true
    end
  end
end
