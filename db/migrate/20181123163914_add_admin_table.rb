class AddAdminTable < ActiveRecord::Migration[5.2]
  def change

    create_table :admins do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "failed_attempts",        default: 0,  null: false
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.string   "type",                   default: "", null: false
    end

  end
end
