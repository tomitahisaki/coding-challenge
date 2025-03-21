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

ActiveRecord::Schema[7.0].define(version: 2025_03_20_231227) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_basic_fees", comment: "契約料金", force: :cascade do |t|
    t.integer "contract_ampere", null: false, comment: "契約アンペア"
    t.decimal "basic_fee", precision: 10, scale: 2, null: false, comment: "基本料金"
    t.bigint "electricity_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_ampere", "electricity_plan_id"], name: "index_contract_fees_on_plan_id_and_ampere", unique: true
    t.index ["electricity_plan_id"], name: "index_contract_basic_fees_on_electricity_plan_id"
  end

  create_table "electricity_plans", comment: "電力プラン", force: :cascade do |t|
    t.string "plan_name", comment: "プラン名"
    t.bigint "electricity_provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electricity_provider_id"], name: "index_electricity_plans_on_electricity_provider_id"
  end

  create_table "electricity_providers", comment: "電力会社", force: :cascade do |t|
    t.string "provider_name", null: false, comment: "電力会社名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usage_rates", comment: "従量料金単価", force: :cascade do |t|
    t.integer "min_kwh", null: false, comment: "最小使用量"
    t.integer "max_kwh", comment: "最大使用量"
    t.decimal "unit_price", precision: 10, scale: 2, null: false, comment: "従量料金単価"
    t.boolean "fix_rate", default: false, null: false, comment: "固定料金フラグ"
    t.bigint "electricity_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electricity_plan_id"], name: "index_usage_rates_on_electricity_plan_id"
  end

  add_foreign_key "contract_basic_fees", "electricity_plans"
  add_foreign_key "electricity_plans", "electricity_providers"
  add_foreign_key "usage_rates", "electricity_plans"
end
