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

ActiveRecord::Schema.define(version: 2019_02_07_182505) do

  create_table "sail_entries", force: :cascade do |t|
    t.string "value", null: false
    t.integer "setting_id"
    t.integer "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_sail_entries_on_profile_id"
    t.index ["setting_id"], name: "index_sail_entries_on_setting_id"
  end

  create_table "sail_profiles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sail_profiles_on_name", unique: true
  end

  create_table "sail_settings", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "value", null: false
    t.integer "cast_type", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group"
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.boolean "real"
    t.text "content"
  end

end
