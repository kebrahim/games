class NbaTeam < ActiveRecord::Base
  attr_accessible :abbreviation, :city, :division, :league, :name
end
