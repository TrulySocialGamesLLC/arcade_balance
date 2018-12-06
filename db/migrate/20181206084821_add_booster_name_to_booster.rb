class AddBoosterNameToBooster < ActiveRecord::Migration[5.2]
  def change
    change_table :boosters do |t|
      t.string :booster_name
    end
  end
end
