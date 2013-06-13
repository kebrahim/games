class MlbStanding < ActiveRecord::Base
  belongs_to :mlb_team
  attr_accessible :losses, :wins, :year

  # returns the number of projected wins based on a 162-game season
  def projected_wins
    games = self.wins + self.losses
    return games > 0 ? ((self.wins / games.to_f) * 162).round : 0
  end

  # returns the number of projected losses based on a 162-game season
  def projected_losses
  	return 162 - self.projected_wins
  end

  # returns the projected result [over/under/push], based on the specified line
  def projected_result(line)
  	wins = self.projected_wins
    if wins < line
      return "Under"
    elsif wins > line
      return "Over"
    else
      return "Push"
    end
  end

  # returns the projected offset between the specified line and the projected wins
  def projected_offset(line)
    proj_result = self.projected_result(line)
    if proj_result == "Over"
      return "+" + (self.projected_wins - line).to_s
    elsif proj_result == "Under"
      return "-" + (line - self.projected_wins).to_s
    else
      return ""
    end
  end
end
