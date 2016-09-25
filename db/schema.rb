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

ActiveRecord::Schema.define(version: 20160924090954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_tokens", force: :cascade do |t|
    t.string   "content",    null: false
    t.integer  "user_id",    null: false
    t.datetime "expired_at", null: false
    t.index ["content"], name: "index_auth_tokens_on_content", unique: true, using: :btree
    t.index ["expired_at"], name: "index_auth_tokens_on_expired_at", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.integer  "birth_year", default: 0,  null: false
    t.string   "eye_color",  default: "", null: false
    t.string   "gender",     default: "", null: false
    t.string   "hair_color", default: "", null: false
    t.integer  "height",     default: 0,  null: false
    t.integer  "mass",       default: 0,  null: false
    t.string   "skin_color", default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "url",                     null: false
    t.integer  "planet_id",               null: false
  end

  create_table "pilots_starships", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "starship_id"
    t.index ["person_id"], name: "index_pilots_starships_on_person_id", using: :btree
    t.index ["starship_id"], name: "index_pilots_starships_on_starship_id", using: :btree
  end

  create_table "planets", force: :cascade do |t|
    t.string   "name"
    t.integer  "rotation_period", default: 0
    t.integer  "orbital_period",  default: 0
    t.integer  "diameter",        default: 0
    t.string   "climate"
    t.string   "gravity"
    t.string   "terrain"
    t.integer  "surface_water",   default: 0
    t.bigint   "population",      default: 0
    t.string   "url",                         null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "starships", force: :cascade do |t|
    t.string   "name",                   default: ""
    t.string   "model",                  default: ""
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "url",                                  null: false
    t.string   "manufacturer"
    t.bigint   "cost_in_credits",        default: 0
    t.integer  "max_atmosphering_speed", default: 0
    t.integer  "passengers",             default: 0
    t.bigint   "cargo_capacity",         default: 0
    t.string   "consumables"
    t.float    "hyperdrive_rating",      default: 0.0
    t.string   "MGLT"
    t.string   "starship_class"
    t.float    "length",                 default: 0.0
    t.integer  "crew",                   default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             null: false
    t.string   "password_digest",                   null: false
    t.string   "auth_token"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "first_name",           default: ""
    t.string   "last_name",            default: ""
    t.string   "reset_password_token"
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

end
