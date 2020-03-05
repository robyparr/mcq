# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_05_131953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.bigint "loggable_id"
    t.string "loggable_type"
    t.string "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "integrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "service"
    t.string "request_token"
    t.string "auth_token"
    t.string "redirect_token"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_integrations_on_user_id"
  end

  create_table "media_items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "media_queue_id", null: false
    t.boolean "complete", default: false, null: false
    t.bigint "media_priority_id"
    t.string "consumption_difficulty"
    t.integer "estimated_consumption_time"
    t.string "service_id"
    t.string "service_type"
    t.index ["media_priority_id"], name: "index_media_items_on_media_priority_id"
    t.index ["media_queue_id"], name: "index_media_items_on_media_queue_id"
    t.index ["user_id"], name: "index_media_items_on_user_id"
  end

  create_table "media_notes", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "media_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["media_item_id"], name: "index_media_notes_on_media_item_id"
  end

  create_table "media_priorities", force: :cascade do |t|
    t.string "title", null: false
    t.integer "priority", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "priority"], name: "index_media_priorities_on_user_id_and_priority", unique: true
    t.index ["user_id", "title"], name: "index_media_priorities_on_user_id_and_title", unique: true
    t.index ["user_id"], name: "index_media_priorities_on_user_id"
  end

  create_table "media_queues", force: :cascade do |t|
    t.string "name", null: false
    t.string "color", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_media_queues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "integrations", "users"
  add_foreign_key "media_items", "media_priorities"
  add_foreign_key "media_items", "media_queues"
  add_foreign_key "media_items", "users"
  add_foreign_key "media_notes", "media_items"
  add_foreign_key "media_priorities", "users"
  add_foreign_key "media_queues", "users"
end
