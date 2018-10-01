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

ActiveRecord::Schema.define(version: 2018_08_31_073148) do

  create_table "hosts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hosts_on_name", unique: true
  end

  create_table "nouns", force: :cascade do |t|
    t.string "word", null: false
    t.integer "count", null: false
    t.integer "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["count"], name: "index_nouns_on_count"
    t.index ["source_id", "word"], name: "index_nouns_on_source_id_and_word", unique: true
    t.index ["source_id"], name: "index_nouns_on_source_id"
    t.index ["word", "source_id"], name: "index_nouns_on_word_and_source_id", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.string "scheme", null: false
    t.string "path", null: false
    t.text "query"
    t.string "fragment"
    t.text "full_path", null: false
    t.integer "host_id", null: false
    t.datetime "crawled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crawled_at"], name: "index_sources_on_crawled_at"
    t.index ["full_path", "host_id"], name: "index_sources_on_full_path_and_host_id", unique: true
    t.index ["host_id", "full_path"], name: "index_sources_on_host_id_and_full_path", unique: true
    t.index ["host_id"], name: "index_sources_on_host_id"
    t.index ["scheme", "path", "query", "fragment", "host_id"], name: "index_sources_on_sc_pa_qu_fr_ho", unique: true
  end

end
