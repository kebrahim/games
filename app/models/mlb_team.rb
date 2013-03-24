class MlbTeam < ActiveRecord::Base
  attr_accessible :abbreviation, :city, :division, :league, :name
  has_many :mlb_wins
end
