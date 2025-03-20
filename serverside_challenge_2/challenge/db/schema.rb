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

ActiveRecord::Schema[7.0].define(version: 2025_03_18_221822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "electricity_plans", "electricity_providers"
end
