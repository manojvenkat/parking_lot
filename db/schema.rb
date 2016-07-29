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

ActiveRecord::Schema.define(version: 20160729170250) do

  create_table "cars", force: :cascade do |t|
    t.string   "reg_no",     null: false
    t.string   "color",      null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cars", ["color"], name: "index_cars_on_color"
  add_index "cars", ["reg_no"], name: "index_cars_on_reg_no"

  create_table "index_reg_no_colors", force: :cascade do |t|
  end

  create_table "parking_spaces", force: :cascade do |t|
    t.string  "name"
    t.integer "slot_count", null: false
  end

  create_table "slots", force: :cascade do |t|
    t.boolean  "occupied",         default: false
    t.integer  "parking_space_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parking_slot_id",  default: 1,     null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.datetime "parked_from",  default: '2016-07-29 16:02:33', null: false
    t.datetime "parked_till"
    t.boolean  "still_parked", default: true
    t.integer  "user_id"
    t.integer  "car_id",                                       null: false
    t.integer  "slot_id",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "num_visited_times", default: 0, null: false
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
