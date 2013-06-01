class FixIndexNbaPlayoffBets < ActiveRecord::Migration
  def self.up
    remove_index :nba_playoff_bets, :year_and_round_and_position
    add_index :nba_playoff_bets, [:year, :round, :position, :user_id],
        {:unique => true, :name => "nba_playoff_bets_year_round_position_user"}
  end

  def self.down
    remove_index :nba_playoff_bets, {:name => "nba_playoff_bets_year_round_position_user"}
    add_index :nba_playoff_bets, [:year, :round, :position], :unique => true
  end
end
