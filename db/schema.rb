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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120527171919) do

  create_table "bets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "stage_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["stage_id"], :name => "index_groups_on_stage_id"

  create_table "match_participations", :force => true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "match_participations", ["match_id"], :name => "index_match_participations_on_match_id"
  add_index "match_participations", ["team_id"], :name => "index_match_participations_on_team_id"

  create_table "matches", :force => true do |t|
    t.integer  "cup_id"
    t.string   "type"
    t.integer  "stage_id"
    t.integer  "home_id"
    t.integer  "guest_id"
    t.integer  "home_score"
    t.integer  "guest_score"
    t.integer  "following_id"
    t.datetime "date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "matches", ["cup_id"], :name => "index_matches_on_cup_id"
  add_index "matches", ["stage_id"], :name => "index_matches_on_stage_id"

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "standings", :force => true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.text     "data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "standings", ["rateable_id", "rateable_type"], :name => "index_standings_on_rateable_id_and_rateable_type"

  create_table "teams", :force => true do |t|
    t.string   "country"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
