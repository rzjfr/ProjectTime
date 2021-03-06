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

ActiveRecord::Schema.define(version: 20150521211522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.integer  "project_conversation_id"
    t.integer  "user_id"
    t.integer  "reciver_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "messages", ["project_conversation_id"], name: "index_messages_on_project_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id", using: :btree

  create_table "project_conversations", force: :cascade do |t|
    t.string   "content"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_conversations", ["project_id"], name: "index_project_conversations_on_project_id", using: :btree
  add_index "project_conversations", ["user_id"], name: "index_project_conversations_on_user_id", using: :btree

  create_table "project_members", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_members", ["project_id"], name: "index_project_members_on_project_id", using: :btree
  add_index "project_members", ["user_id"], name: "index_project_members_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title"
    t.string   "description"
    t.integer  "milestone_id"
    t.integer  "estimate"
    t.integer  "creator_id"
    t.integer  "assignee_id"
    t.string   "state"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "row_order"
    t.string   "task_class"
    t.string   "title_digest"
  end

  add_index "tasks", ["milestone_id"], name: "index_tasks_on_milestone_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "messages", "project_conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "milestones", "projects"
  add_foreign_key "project_conversations", "projects"
  add_foreign_key "project_conversations", "users"
  add_foreign_key "project_members", "projects"
  add_foreign_key "project_members", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "tasks", "milestones"
  add_foreign_key "tasks", "projects"
end
