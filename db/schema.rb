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

ActiveRecord::Schema.define(:version => 20130324223359) do

  create_table "mlb_teams", :force => true do |t|
    t.string   "city"
    t.string   "name"
    t.string   "abbreviation"
    t.string   "division"
    t.string   "league"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "mlb_win_bets", :force => true do |t|
    t.integer  "mlb_win_id"
    t.integer  "user_id"
    t.string   "prediction"
    t.integer  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mlb_win_bets", ["mlb_win_id"], :name => "index_mlb_win_bets_on_mlb_win_id"
  add_index "mlb_win_bets", ["user_id"], :name => "index_mlb_win_bets_on_user_id"

  create_table "mlb_wins", :force => true do |t|
    t.integer  "mlb_team_id"
    t.integer  "year"
    t.float    "line"
    t.integer  "actual"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "mlb_wins", ["mlb_team_id"], :name => "index_mlb_wins_on_mlb_team_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.boolean  "is_admin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
