class MlbStanding < ActiveRecord::Base
  belongs_to :mlb_team
  attr_accessible :losses, :wins, :year
end
