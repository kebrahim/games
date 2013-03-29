class MlbWin < ActiveRecord::Base
  attr_accessible :actual, :line, :year
  belongs_to :mlb_team
  has_many :mlb_win_bets
end
