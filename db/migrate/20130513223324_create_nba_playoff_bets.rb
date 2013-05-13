class CreateNbaPlayoffBets < ActiveRecord::Migration
  def change
    create_table :nba_playoff_bets do |t|
      t.integer :year
      t.belongs_to :user
      t.belongs_to :nba_playoff_matchup
      t.belongs_to :expected_nba_team, :class_name => 'NbaTeam', :foreign_key => "expected_nba_team_id"
      t.integer :expected_total_games
      t.integer :points

      t.timestamps
    end
    add_index :nba_playoff_bets, :user_id
    add_index :nba_playoff_bets, :nba_playoff_matchup_id
    add_index :nba_playoff_bets, :expected_nba_team_id
  end
end
