# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_11_154118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "", null: false
    t.string "access_key"
  end

  create_table "boosters", force: :cascade do |t|
    t.string "name"
    t.string "minigame_key"
    t.integer "tier"
    t.boolean "enabled"
    t.bigint "configuration_id", null: false
    t.string "booster_name"
    t.index ["configuration_id"], name: "index_boosters_on_configuration_id"
  end

  create_table "common_ticket_timers", force: :cascade do |t|
    t.float "time"
    t.json "reward"
    t.bigint "configuration_id", null: false
    t.integer "step"
    t.index ["configuration_id"], name: "index_common_ticket_timers_on_configuration_id"
  end

  create_table "configurations", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.jsonb "initial_data", default: {}
  end

  create_table "fake_table", force: :cascade do |t|
    t.string "scene"
  end

  create_table "media_files", force: :cascade do |t|
    t.json "data"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_media_files_on_owner_type_and_owner_id"
  end

  create_table "minigames", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.text "description"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_minigames_on_key", unique: true
  end

  create_table "scheduled_games", force: :cascade do |t|
    t.bigint "minigame_id"
    t.date "scheduled_date"
    t.datetime "inserted_at", null: false
    t.datetime "updated_at", null: false
    t.index ["minigame_id", "scheduled_date"], name: "index_scheduled_games_on_minigame_id_and_scheduled_date", unique: true
    t.index ["minigame_id"], name: "index_scheduled_games_on_minigame_id"
  end

  create_table "shop_items", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.integer "priority", limit: 2
    t.integer "sorting", limit: 2
    t.json "balance"
    t.string "ios_id"
    t.string "android_id"
    t.boolean "enabled"
    t.datetime "inserted_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests_hud_ab_tests", force: :cascade do |t|
    t.string "scene"
    t.string "test"
    t.bigint "configuration_id", null: false
    t.index ["configuration_id"], name: "index_tests_hud_ab_tests_on_configuration_id"
  end

  create_table "wheels_categories", force: :cascade do |t|
    t.string "name"
    t.integer "count"
    t.string "type"
    t.bigint "configuration_id", null: false
    t.index ["configuration_id"], name: "index_wheels_categories_on_configuration_id"
  end

  create_table "wheels_lots", force: :cascade do |t|
    t.integer "weights"
    t.string "material"
    t.string "category"
    t.string "type"
    t.bigint "configuration_id", null: false
    t.integer "unique_key"
    t.integer "count"
    t.index ["configuration_id"], name: "index_wheels_lots_on_configuration_id"
  end

  add_foreign_key "scheduled_games", "minigames", on_delete: :cascade
end
