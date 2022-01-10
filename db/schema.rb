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

ActiveRecord::Schema.define(version: 2022_01_09_211206) do

  create_table "links", force: :cascade do |t|
    t.string "url", null: false
    t.string "slug", null: false
    t.datetime "expire_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid", null: false
    t.index ["expire_at"], name: "index_links_on_expire_at"
    t.index ["slug"], name: "index_links_on_slug"
    t.index ["uuid"], name: "index_links_on_uuid"
  end

end
