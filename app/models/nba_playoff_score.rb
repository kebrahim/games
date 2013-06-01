class NbaPlayoffScore < ActiveRecord::Base
  attr_accessible :name, :points, :round

  BONUS_GAMES_ROUND = 5
end
