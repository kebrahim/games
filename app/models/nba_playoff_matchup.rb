class NbaPlayoffMatchup < ActiveRecord::Base
  attr_accessible :position, :round, :nba_team1_id, :team1_seed, :nba_team2_id, :team2_seed, :winning_nba_team_id, :total_games, :year
end
