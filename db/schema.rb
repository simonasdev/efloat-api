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

ActiveRecord::Schema.define(version: 2019_06_15_132907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_lines", force: :cascade do |t|
    t.bigint "device_id"
    t.text "data"
    t.datetime "timestamp"
    t.float "battery_voltage"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.text "cardinal_direction"
    t.float "altitude"
    t.integer "orientation", default: 0
    t.integer "sos_count"
    t.integer "ok_count"
    t.boolean "check", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "speed"
    t.bigint "race_id"
    t.bigint "limited_track_id"
    t.index ["device_id", "race_id"], name: "index_data_lines_on_device_id_and_race_id"
    t.index ["device_id"], name: "index_data_lines_on_device_id"
    t.index ["limited_track_id"], name: "index_data_lines_on_limited_track_id"
    t.index ["race_id"], name: "index_data_lines_on_race_id"
    t.index ["timestamp"], name: "index_data_lines_on_timestamp"
  end

  create_table "devices", force: :cascade do |t|
    t.text "number"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0, null: false
    t.boolean "online", default: false, null: false
    t.text "comment"
    t.text "index"
    t.jsonb "crew_data", default: {}, null: false
    t.integer "current_data_line_id"
    t.text "position"
    t.text "state"
    t.index ["current_data_line_id"], name: "index_devices_on_current_data_line_id"
    t.index ["kind"], name: "index_devices_on_kind"
    t.index ["position"], name: "index_devices_on_position"
    t.index ["state"], name: "index_devices_on_state"
  end

  create_table "driver_devices", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "device_id"
    t.bigint "race_id"
    t.text "position"
    t.text "state"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_driver_devices_on_device_id"
    t.index ["driver_id"], name: "index_driver_devices_on_driver_id"
    t.index ["position"], name: "index_driver_devices_on_position"
    t.index ["race_id"], name: "index_driver_devices_on_race_id"
    t.index ["state"], name: "index_driver_devices_on_state"
  end

  create_table "drivers", force: :cascade do |t|
    t.text "name"
    t.integer "kind", default: 0, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_drivers_on_kind"
    t.index ["name"], name: "index_drivers_on_name"
  end

  create_table "markers", force: :cascade do |t|
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.integer "kind", default: 0, null: false
    t.text "number"
    t.bigint "race_id"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_markers_on_kind"
    t.index ["race_id"], name: "index_markers_on_race_id"
    t.index ["track_id"], name: "index_markers_on_track_id"
  end

  create_table "points", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.bigint "track_id"
    t.index ["track_id"], name: "index_points_on_track_id"
    t.index ["x", "y", "track_id"], name: "index_points_on_x_and_y_and_track_id", unique: true
    t.index ["x", "y"], name: "index_points_on_x_and_y"
  end

  create_table "races", force: :cascade do |t|
    t.text "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "speed_exceed_processed", default: false
  end

  create_table "speed_exceed_data_lines", force: :cascade do |t|
    t.bigint "race_id"
    t.bigint "limited_track_id"
    t.bigint "device_id"
    t.text "data"
    t.datetime "timestamp"
    t.float "battery_voltage"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.text "cardinal_direction"
    t.float "altitude"
    t.integer "orientation", default: 0
    t.integer "sos_count"
    t.integer "ok_count"
    t.boolean "check", default: false, null: false
    t.float "speed"
    t.float "speed_exceeded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_speed_exceed_data_lines_on_device_id"
    t.index ["limited_track_id"], name: "index_speed_exceed_data_lines_on_limited_track_id"
    t.index ["race_id"], name: "index_speed_exceed_data_lines_on_race_id"
  end

  create_table "speed_exceed_events", force: :cascade do |t|
    t.bigint "race_id", null: false
    t.bigint "track_id", null: false
    t.bigint "device_id", null: false
    t.integer "data_line_ids", null: false, array: true
    t.integer "seconds", null: false
    t.float "average_speed"
    t.index ["device_id"], name: "index_speed_exceed_events_on_device_id"
    t.index ["race_id"], name: "index_speed_exceed_events_on_race_id"
    t.index ["seconds"], name: "index_speed_exceed_events_on_seconds"
    t.index ["track_id"], name: "index_speed_exceed_events_on_track_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.text "identifier"
    t.text "barcode"
    t.boolean "passed"
    t.boolean "can_enter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_tickets_on_barcode"
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "race_id"
    t.float "speed_limit"
    t.jsonb "route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0, null: false
    t.text "name"
    t.float "length"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["kind"], name: "index_tracks_on_kind"
    t.index ["race_id"], name: "index_tracks_on_race_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
