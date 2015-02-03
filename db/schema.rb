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

ActiveRecord::Schema.define(version: 20150203015302) do

  create_table "authors", force: :cascade do |t|
    t.integer  "remote_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "default_category_id"
    t.text     "data"
  end

  add_index "authors", ["remote_id"], name: "index_authors_on_remote_id", unique: true
  add_index "authors", ["last_name", "first_name"], name: "index_authors_on_name", unique: true

  create_table "categories", force: :cascade do |t|
    t.integer  "remote_id"
    t.string   "name"
    t.integer  "parent_id"
  end

  add_index "categories", ["remote_id"], name: "index_categories_on_remote_id", unique: true
  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "journals", force: :cascade do |t|
    t.integer  "remote_id"
    t.datetime "posted_at"
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.string   "author_name"
    t.integer  "category_id"
    t.integer  "week"
    t.boolean  "read"
    t.text     "data"
  end

  add_index "journals", ["remote_id"], name: "index_journals_on_remote_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gh_username"
    t.string   "gh_token"
    t.text     "gh_data"
    t.string   "teamwork_api_key"
  end

  add_index "users", ["gh_username"], name: "index_users_on_gh_username", unique: true

end
