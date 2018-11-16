class RenameCategoryColumn < ActiveRecord::Migration[5.2]
  def change

    change_table :wheels_categories do |t|
      t.rename :category, :name
    end

  end
end
