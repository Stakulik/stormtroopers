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

ActiveRecord::Schema.define(version: 20160608223848) do

  create_table "people", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "birth_year", default: "", null: false
    t.string   "eye_color",  default: "", null: false
    t.string   "gender",     default: "", null: false
    t.string   "hair_color", default: "", null: false
    t.string   "height",     default: "", null: false
    t.string   "mass",       default: "", null: false
    t.string   "skin_color", default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "people_starships", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "starship_id"
    t.index ["person_id"], name: "index_people_starships_on_person_id"
    t.index ["starship_id"], name: "index_people_starships_on_starship_id"
  end

  create_table "starships", force: :cascade do |t|
    t.string   "name",       default: ""
    t.string   "model",      default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end