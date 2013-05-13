class NbaPlayoffBet < ActiveRecord::Base
  belongs_to :user
  belongs_to :nba_playoff_matchup
  belongs_to :expected_nba_team, :class_name => 'NbaTeam', :foreign_key => "expected_nba_team_id"

  attr_accessible :expected_total_games, :points, :year

  validates_presence_of :year
  validates_presence_of :user
  validates_presence_of :nba_playoff_matchup
  validates_presence_of :expected_nba_team
  validates_presence_of :expected_total_games

end
