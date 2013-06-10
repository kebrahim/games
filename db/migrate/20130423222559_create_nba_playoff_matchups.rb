class CreateNbaPlayoffMatchups < ActiveRecord::Migration
  def change
    create_table :nba_playoff_matchups do |t|
      t.integer :year
      t.integer :round
      t.integer :position
      t.belongs_to :nba_team1, :class_name => 'NbaTeam', :foreign_key => "nba_team1_id"
      t.integer :team1_seed
      t.belongs_to :nba_team2, :class_name => 'NbaTeam', :foreign_key => "nba_team2_id"
      t.integer :team2_seed
      t.belongs_to :winning_nba_team, :class_name => 'NbaTeam', :foreign_key => "winning_nba_team_id"
      t.integer :total_games

      t.timestamps
    end

    add_index :nba_playoff_matchups, :nba_team1_id
    add_index :nba_playoff_matchups, :nba_team2_id
    add_index :nba_playoff_matchups, :winning_nba_team_id
  end
end
