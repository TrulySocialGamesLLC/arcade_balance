class AddImagePathAndVisualStylingToShopItems < ActiveRecord::Migration[5.2]
  def change
    add_column :shop_items, :image_path, :string
    add_column :shop_items, :visual_styling, :json
  end
end
