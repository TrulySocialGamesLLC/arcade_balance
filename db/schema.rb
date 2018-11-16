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

ActiveRecord::Schema.define(version: 2018_11_16_153841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configurations", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_files", force: :cascade do |t|
    t.json "data"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_media_files_on_owner_type_and_owner_id"
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
    t.integer "count"
    t.string "category"
    t.string "type"
    t.bigint "configuration_id", null: false
    t.integer "unique_key"
    t.index ["configuration_id"], name: "index_wheels_lots_on_configuration_id"
  end

  create_table "wheels_ticket_timers", force: :cascade do |t|
    t.decimal "time"
    t.json "reward"
    t.bigint "configuration_id", null: false
    t.index ["configuration_id"], name: "index_wheels_ticket_timers_on_configuration_id"
  end

end
