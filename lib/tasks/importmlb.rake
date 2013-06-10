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

  desc "Populates MLB standings data from MLB teams CSV file"
  task :standings => :environment do
    require 'csv'
    teamcount = 0
    year = Date.today.year

    # Only populate data if it doesn't aleady exist.
    if MlbStanding.where(year: year).count == 0
      CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/mlb_teams.csv")) do |row|
        abbreviation = row[0]
        team = MlbTeam.find_by_abbreviation(abbreviation)
        if !team.nil?
          standing = MlbStanding.create(year: year, wins: 0, losses: 0)
          standing.update_attribute(:mlb_team_id, team.id)
          teamcount += 1
        end
      end
      puts "Created " + teamcount.to_s + " MLB standings records for " + year.to_s + "!"
    else
      puts "MLB Standings data for " + year.to_s + " already exists!"
    end
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

  desc "Imports MLB over/under bet data from CSV file"
  task :overunderbets => :environment do
    require 'csv'
    betcount = 0
    year = Date.today.year
    CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/mlb_win_bets.csv")) do |row|
      email = row[0]
      team_abbreviation = row[1]
      prediction = row[2]
      amount = row[3].to_i

      user = User.where(email: email).first
      team = MlbTeam.where(abbreviation: team_abbreviation).first
      if !team.nil?
        win = MlbWin.where(year: year, mlb_team_id: team.id).first
        if !win.nil? && !user.nil?
          bet = MlbWinBet.create(prediction: prediction, amount: amount)
          bet.update_attribute(:user_id, user.id)
          bet.update_attribute(:mlb_win_id, win.id)
          betcount += 1
        end
      end
    end
    puts "Imported " + betcount.to_s + " MLB over/under bets for " + year.to_s + "!"
  end
end