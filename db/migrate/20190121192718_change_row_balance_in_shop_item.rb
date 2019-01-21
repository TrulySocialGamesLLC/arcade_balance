class ChangeRowBalanceInShopItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :shop_items, :balance, :rewards
  end
end
