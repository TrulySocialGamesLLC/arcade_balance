class CreateTableShopItems < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_items do |t|
      t.string :name
      t.string :category
      t.integer :priority, limit: 2
      t.integer :sorting, limit: 2
      t.json :balance
      t.string :ios_id
      t.string :android_id
      t.boolean :enabled

      t.timestamps
    end
  end
end
