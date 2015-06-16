# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150616041653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "etf_prices", id: false, force: :cascade do |t|
    t.string   "name",         limit: 255,                          null: false
    t.string   "date",         limit: 255,                          null: false
    t.decimal  "open",                     precision: 20, scale: 2, null: false
    t.decimal  "close",                    precision: 20, scale: 2, null: false
    t.decimal  "high",                     precision: 20, scale: 2, null: false
    t.decimal  "low",                      precision: 20, scale: 2, null: false
    t.integer  "volume",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                      null: false
  end

  add_index "etf_prices", ["name", "date"], name: "primary_key_idx", unique: true, using: :btree

  create_table "positions", id: false, force: :cascade do |t|
    t.string   "name",          limit: 255,                          null: false
    t.decimal  "average_price",             precision: 20, scale: 2, null: false
    t.integer  "quantity",                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                       null: false
    t.string   "strategy",      limit: 255
  end

  add_index "positions", ["name"], name: "index_positions_on_name", unique: true, using: :btree

  create_table "transactions", force: :cascade do |t|
    t.string   "name",         limit: 255,                          null: false
    t.integer  "quantity",                                          null: false
    t.decimal  "price",                    precision: 20, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                      null: false
    t.string   "strategy",     limit: 255
  end

end
