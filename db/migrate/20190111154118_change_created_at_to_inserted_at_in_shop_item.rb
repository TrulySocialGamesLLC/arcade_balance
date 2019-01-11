class ChangeCreatedAtToInsertedAtInShopItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :shop_items, :created_at, :inserted_at
  end
end
