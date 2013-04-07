class MlbWinBet < ActiveRecord::Base
  attr_accessible :amount, :prediction
  belongs_to :mlb_win
  belongs_to :user

  # returns the corresponding prediction name for the specified id and an empty string if there's
  # no matching name
  def self.predictionName(betId)
    if betId == "1"
      return "Over"
    elsif betId == "2"
      return "Under"
    else
      return ""
    end
  end
end
