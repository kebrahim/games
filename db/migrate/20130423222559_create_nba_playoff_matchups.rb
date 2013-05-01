class CreateNbaPlayoffMatchups < ActiveRecord::Migration
  def change
    create_table :nba_playoff_matchups do |t|
      t.integer :year
      t.integer :round
      t.integer :position
      t.integer :nba_team1_id
      t.integer :team1_seed
      t.integer :nba_team2_id
      t.integer :team2_seed
      t.integer :winning_nba_team_id
      t.integer :total_games

      t.timestamps
    end

    #add_index :nba_playoff_matchups, [:year, :nba_team1_id, :nba_team2_id], :unique => true
    #add_index :nba_playoff_matchups, [:year, :round, :position], :unique => true
    add_index :nba_playoff_matchups, :nba_team1_id
    add_index :nba_playoff_matchups, :nba_team2_id
    add_index :nba_playoff_matchups, :winning_nba_team_id
  end
end
