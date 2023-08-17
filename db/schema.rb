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

ActiveRecord::Schema[7.0].define(version: 2023_08_17_130942) do
  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "item_version", null: false
    t.integer "department_id", null: false
    t.integer "requested_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "created", null: false
    t.datetime "verified_at"
    t.integer "verified_by_id"
    t.index ["department_id"], name: "index_inventories_on_department_id"
    t.index ["item_id"], name: "index_inventories_on_item_id"
    t.index ["verified_by_id"], name: "index_inventories_on_verified_by_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "model_number"
    t.text "description"
    t.string "reference_url"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "inventories", "departments"
  add_foreign_key "inventories", "items"
  add_foreign_key "inventories", "users", column: "verified_by_id"
end
