class AddLotIdAttr < ActiveRecord::Migration[5.2]
  def change

    change_table :wheels_lots do |t|
      t.integer :unique_key
    end

  end
end
