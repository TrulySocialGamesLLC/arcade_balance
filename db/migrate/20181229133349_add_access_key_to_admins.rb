class AddAccessKeyToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :access_key, :string
  end
end
