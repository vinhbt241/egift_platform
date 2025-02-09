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

ActiveRecord::Schema[7.2].define(version: 2025_02_09_082209) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.jsonb "notes", default: {}
    t.string "trackable_type"
    t.uuid "trackable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
  end

  create_table "brands", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "state", default: 0
    t.string "name", null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_brands_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_brands_on_user_id"
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "client_id"
    t.integer "status", default: 0
    t.string "activation_number", null: false
    t.string "pin_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_cards_on_client_id"
    t.index ["pin_number", "activation_number"], name: "index_cards_on_pin_number_and_activation_number", unique: true
    t.index ["product_id"], name: "index_cards_on_product_id"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.decimal "payout_rate", precision: 5, scale: 2, default: "100.0"
    t.string "name", null: false
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_clients_on_identifier", unique: true
    t.index ["name", "user_id"], name: "index_clients_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "field_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_field_types_on_name", unique: true
  end

  create_table "fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "field_type_id"
    t.string "field_customizable_type"
    t.uuid "field_customizable_id"
    t.text "data"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_customizable_type", "field_customizable_id"], name: "index_fields_on_field_customizable"
    t.index ["field_type_id"], name: "index_fields_on_field_type_id"
  end

  create_table "product_accesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_product_accesses_on_client_id"
    t.index ["product_id", "client_id"], name: "index_product_accesses_on_product_id_and_client_id", unique: true
    t.index ["product_id"], name: "index_product_accesses_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "state", default: 0
    t.uuid "brand_id"
    t.decimal "price", precision: 21, scale: 3, null: false
    t.string "currency", limit: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "brands", "users"
  add_foreign_key "cards", "clients"
  add_foreign_key "cards", "products"
  add_foreign_key "clients", "users"
  add_foreign_key "fields", "field_types"
  add_foreign_key "product_accesses", "clients"
  add_foreign_key "product_accesses", "products"
  add_foreign_key "products", "brands"
end
