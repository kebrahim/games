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

ActiveRecord::Schema.define(:version => 20130610333333) do

  create_table "mlb_standings", :force => true do |t|
    t.integer  "year"
    t.integer  "mlb_team_id"
    t.integer  "wins"
    t.integer  "losses"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "mlb_standings", ["mlb_team_id"], :name => "index_mlb_standings_on_mlb_team_id"
  add_index "mlb_standings", ["year", "mlb_team_id"], :name => "mlb_standings_year_team", :unique => true

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

  create_table "nba_playoff_bets", :force => true do |t|
    t.integer  "year"
    t.integer  "user_id"
    t.integer  "expected_nba_team_id"
    t.integer  "expected_total_games"
    t.integer  "points"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "round"
    t.integer  "position"
  end

  add_index "nba_playoff_bets", ["expected_nba_team_id"], :name => "index_nba_playoff_bets_on_expected_nba_team_id"
  add_index "nba_playoff_bets", ["user_id"], :name => "index_nba_playoff_bets_on_user_id"
  add_index "nba_playoff_bets", ["year", "round", "position", "user_id"], :name => "nba_playoff_bets_year_round_position_user", :unique => true

  create_table "nba_playoff_matchups", :force => true do |t|
    t.integer  "year"
    t.integer  "round"
    t.integer  "position"
    t.integer  "nba_team1_id"
    t.integer  "team1_seed"
    t.integer  "nba_team2_id"
    t.integer  "team2_seed"
    t.integer  "winning_nba_team_id"
    t.integer  "total_games"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "nba_playoff_matchups", ["nba_team1_id"], :name => "index_nba_playoff_matchups_on_nba_team1_id"
  add_index "nba_playoff_matchups", ["nba_team2_id"], :name => "index_nba_playoff_matchups_on_nba_team2_id"
  add_index "nba_playoff_matchups", ["winning_nba_team_id"], :name => "index_nba_playoff_matchups_on_winning_nba_team_id"
  add_index "nba_playoff_matchups", ["year", "nba_team1_id", "nba_team2_id"], :name => "nba_playoff_matchups_year_teams", :unique => true
  add_index "nba_playoff_matchups", ["year", "round", "position"], :name => "nba_playoff_matchups_year_round_position", :unique => true

  create_table "nba_playoff_scores", :force => true do |t|
    t.integer  "round"
    t.integer  "points"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nba_teams", :force => true do |t|
    t.string   "city"
    t.string   "name"
    t.string   "abbreviation"
    t.string   "division"
    t.string   "league"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "is_admin"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
