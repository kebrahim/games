class NbaPlayoffBet < ActiveRecord::Base
  belongs_to :user
  belongs_to :expected_nba_team, :class_name => 'NbaTeam', :foreign_key => "expected_nba_team_id"

  attr_accessible :expected_nba_team, :expected_total_games, :points, :year, :round, :position

  validates_presence_of :year
  validates_presence_of :round
  validates_presence_of :position
  validates_presence_of :user
  validates_presence_of :expected_nba_team
  validates_presence_of :expected_total_games

end
