namespace :importmlb do

  # environment is a rake task that loads all models
  desc "Imports MLB team data from CSV file"
  task :teams => :environment do
    require 'csv'
    teamcount = 0
    CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/mlb_teams.csv")) do |row|
      abbreviation = row[0]
      city = row[1]
      division = row[2]
      league = row[3]
      name = row[4]
      team = MlbTeam.create(abbreviation: abbreviation, city: city, division: division,
          league: league, name: name)
      teamcount += 1
    end
    puts "Imported " + teamcount.to_s + " MLB teams!"
  end

  desc "Imports MLB over/under data from CSV file"
  task :wins => :environment do
    require 'csv'
    wincount = 0
    year = Date.today.year
    CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/mlb_wins.csv")) do |row|
      abbreviation = row[0]
      wins = row[1].to_f
      team = MlbTeam.where(abbreviation: abbreviation).first
      if !team.nil?
        win = MlbWin.create(line: wins, year: year)
        win.update_attribute(:mlb_team_id, team.id)
        wincount += 1
      end
    end
    puts "Imported " + wincount.to_s + " MLB lines for " + year.to_s + "!"
  end
end