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

ActiveRecord::Schema.define(version: 2021_01_08_005109) do

  create_table "distances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "st_lat", precision: 8, scale: 6
    t.decimal "st_lng", precision: 9, scale: 6
    t.decimal "ed_lat", precision: 8, scale: 6
    t.decimal "ed_lng", precision: 9, scale: 6
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
