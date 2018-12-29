class AddMinMaxToWheelLots < ActiveRecord::Migration[5.2]
  def up
    add_column :wheels_lots, :min, :integer
    add_column :wheels_lots, :max, :integer
    remove_column :wheels_lots, :count
  end

  def down
    remove_column :wheels_lots, :min
    remove_column :wheels_lots, :max
    add_column :wheels_lots, :count, :integer
  end
end
