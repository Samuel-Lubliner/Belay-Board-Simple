# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_30_165721) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.string "event_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "climbers", force: :cascade do |t|
    t.string "bio", default: "add bio ..."
    t.boolean "is_staff", default: false
    t.boolean "boulder", default: false
    t.boolean "top_rope", default: false
    t.boolean "lead", default: false
    t.boolean "vertical", default: false
    t.boolean "slab", default: false
    t.boolean "overhang", default: false
    t.boolean "beginner", default: false
    t.boolean "intermediate", default: false
    t.boolean "advanced", default: false
    t.boolean "sport", default: false
    t.boolean "trad", default: false
    t.boolean "indoor", default: false
    t.boolean "outdoor", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_climbers_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.bigint "availability_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_comments_on_availability_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "event_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "availability_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_event_requests_on_availability_id"
    t.index ["user_id"], name: "index_event_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.citext "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "availabilities", "users"
  add_foreign_key "climbers", "users"
  add_foreign_key "comments", "availabilities"
  add_foreign_key "comments", "users"
  add_foreign_key "event_requests", "availabilities"
  add_foreign_key "event_requests", "users"
end
