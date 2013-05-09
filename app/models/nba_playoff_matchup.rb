class NbaPlayoffMatchup < ActiveRecord::Base
  attr_accessible :position, :round, :nba_team1_id, :team1_seed, :nba_team2_id, :team2_seed, :winning_nba_team_id, :total_games, :year
  belongs_to :nba_team1, :class_name => 'NbaTeam', :foreign_key => "nba_team1_id"
  belongs_to :nba_team2, :class_name => 'NbaTeam', :foreign_key => "nba_team2_id"
  belongs_to :winning_nba_team, :class_name => 'NbaTeam', :foreign_key => "winning_nba_team_id"

  validates_presence_of :year
  validates_presence_of :position
  validates_presence_of :round
  validates_presence_of :nba_team1_id
  validates_presence_of :team1_seed
  validates_presence_of :nba_team2_id
  validates_presence_of :team2_seed

  # returns the seed of the winning team, or -1 if neither team IDs match.
  def getWinningSeed
    if (self.nba_team1_id = self.winning_nba_team_id)
      return self.team1_seed
    elsif (self.nba_team2_id = self.winning_nba_team_id)
      return self.team2_seed
    end
    return -1
  end

  # returns true if a winner has been decided
  def hasWinner
    return !self.winning_nba_team_id.nil? && self.winning_nba_team_id != 0 &&
           !self.total_games.nil? && self.total_games != 0
  end
end
