class AddUniqueIndicesNbaPlayoffMatchups < ActiveRecord::Migration
  def self.up
    add_index :nba_playoff_matchups, [:year, :round, :position],
        {:unique => true, :name => "nba_playoff_matchups_year_round_position"}
    add_index :nba_playoff_matchups, [:year, :nba_team1_id, :nba_team2_id],
        {:unique => true, :name => "nba_playoff_matchups_year_teams"}
  end

  def self.down
    remove_index :nba_playoff_matchups, {:name => "nba_playoff_matchups_year_round_position"}
    remove_index :nba_playoff_matchups, {:name => "nba_playoff_matchups_year_teams"}
  end
end
