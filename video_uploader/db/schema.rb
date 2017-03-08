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

ActiveRecord::Schema.define(version: 20170307014413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "presentations", force: :cascade do |t|
    t.string  "title"
    t.text    "description"
    t.string  "foreign_uid"
    t.string  "source"
    t.date    "presented_at"
    t.string  "status",        default: "pending", null: false
    t.boolean "active",        default: true
    t.string  "uploaded_file"
    t.string  "video_id"
    t.string  "video_source",  default: "youtube"
    t.index ["active"], name: "index_presentations_on_active", using: :btree
    t.index ["foreign_uid", "source"], name: "index_presentations_on_foreign_uid_and_source", using: :btree
  end

end
