class AddWheelTables < ActiveRecord::Migration[5.2]
  def change

    create_table :wheels_lots do |t|
      t.integer :weights
      t.string  :material
      t.integer :count
      t.string  :category
      t.string  :type

      t.belongs_to :configuration, index: true, null: false
    end

    create_table :wheels_categories do |t|
      t.string  :category
      t.integer :count
      t.string  :type

      t.belongs_to :configuration, index: true, null: false
    end

  end
end
