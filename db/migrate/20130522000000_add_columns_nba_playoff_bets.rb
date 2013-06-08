class AddColumnsNbaPlayoffBets < ActiveRecord::Migration
  def self.up
    add_column :nba_playoff_bets, :round, :integer
    add_column :nba_playoff_bets, :position, :integer
    add_index :nba_playoff_bets, [:year, :round, :position],
        {:unique => true, :name => "nba_playoff_bets_year_round_position"}
    remove_index :nba_playoff_bets, :nba_playoff_matchup_id
    remove_column :nba_playoff_bets, :nba_playoff_matchup_id
  end

  def self.down
    remove_index :nba_playoff_bets, {:name => "nba_playoff_bets_year_round_position_user"}
    remove_column :nba_playoff_bets, :round
    remove_column :nba_playoff_bets, :position
    add_column :nba_playoff_bets, :nba_playoff_matchup_id
    add_index :nba_playoff_bets, :nba_playoff_matchup_id
  end
end
