namespace :importmlb do
  desc "imports MLB over/under data from CSV file"

  # environment is a rake task that loads all models
  task :data => :environment do
    require 'csv'
    CSV.foreach('/Users/kebrahim/Dropbox/games/mlb_teams.csv') do |row|
      abbreviation = row[0]
      city = row[1]
      division = row[2]
      league = row[3]
      name = row[4]
      wins = row[5].to_f
      team = MlbTeam.create(abbreviation: abbreviation, city: city, division: division, league: league,
          name: name)
      win = MlbWin.create(line: wins, year: 2013)
      win.update_attribute(:mlb_team_id, team.id)
    end
  end
end