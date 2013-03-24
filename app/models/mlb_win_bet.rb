class MlbWinBet < ActiveRecord::Base
  attr_accessible :amount, :prediction
  belongs_to :mlb_win
  belongs_to :user
end
