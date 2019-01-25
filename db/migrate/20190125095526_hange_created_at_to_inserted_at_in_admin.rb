class HangeCreatedAtToInsertedAtInAdmin < ActiveRecord::Migration[5.2]
  def change
    rename_column :admins, :created_at, :inserted_at
  end
end
