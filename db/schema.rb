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

ActiveRecord::Schema[7.1].define(version: 2024_11_06_222848) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carts", force: :cascade do |t|
    t.json "items"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount_percentage"
    t.datetime "completed_at"
    t.decimal "original_total", precision: 16, scale: 2
    t.decimal "discount_amount", precision: 16, scale: 2
    t.decimal "final_total", precision: 16, scale: 2
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.integer "discount_percentage"
    t.datetime "expires_at"
    t.integer "max_redemptions"
    t.integer "redemptions_count"
    t.boolean "is_redeemable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expiration_date"
  end

  create_table "user_coupons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "coupon_id", null: false
    t.datetime "redeemed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.bigint "cart_id"
    t.index ["cart_id"], name: "index_user_coupons_on_cart_id"
    t.index ["coupon_id"], name: "index_user_coupons_on_coupon_id"
    t.index ["user_id"], name: "index_user_coupons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "carts", "users"
  add_foreign_key "user_coupons", "carts"
  add_foreign_key "user_coupons", "coupons"
  add_foreign_key "user_coupons", "users"
end
