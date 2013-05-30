class AddColumnsNbaPlayoffBets < ActiveRecord::Migration
  def self.up
    add_column :nba_playoff_bets, :round, :integer
    add_column :nba_playoff_bets, :position, :integer
    add_index :nba_playoff_bets, [:year, :round, :position], :unique => true
    remove_index :nba_playoff_bets, :nba_playoff_matchup_id
    remove_column :nba_playoff_bets, :nba_playoff_matchup_id
  end

  def self.down
    remove_index :nba_playoff_bets, :index_nba_playoff_bets_on_year_and_round_and_position
    remove_column :nba_playoff_bets, :round
    remove_column :nba_playoff_bets, :position
    add_column :nba_playoff_bets, :nba_playoff_matchup_id
    add_index :nba_playoff_bets, :nba_playoff_matchup_id
  end
end
