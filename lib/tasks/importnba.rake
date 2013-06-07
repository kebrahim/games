namespace :importnba do

  # environment is a rake task that loads all models
  desc "Imports NBA team data from CSV file"
  task :teams => :environment do
    require 'csv'
    teamcount = 0
    CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/nba_teams.csv")) do |row|
      city = row[0]
      name = row[1]
      abbreviation = row[2]
      league = row[3]
      division = row[4]
      team = NbaTeam.create(abbreviation: abbreviation, city: city, division: division,
          league: league, name: name)
      teamcount += 1
    end
    puts "Imported " + teamcount.to_s + " NBA teams!"
  end

  desc "Imports NBA playoff matchup data from CSV file"
  task :playoff_matchups => :environment do
    require 'csv'
    matchupct = 0
    year = Date.today.year
    CSV.foreach(File.join(
    	File.expand_path(::Rails.root), "/lib/assets/nba_playoff_matchups.csv")) do |row|
      position = row[0].to_i
      team1_seed = row[1].to_i
      team1_abbreviation = row[2]
      team2_seed = row[3].to_i
      team2_abbreviation = row[4]
      team1 = NbaTeam.where(abbreviation: team1_abbreviation).first
      team2 = NbaTeam.where(abbreviation: team2_abbreviation).first
      if !team1.nil? && !team2.nil?
        NbaPlayoffMatchup.create(year: year, round: 1, position: position, nba_team1_id: team1.id,
        	team1_seed: team1_seed, nba_team2_id: team2.id, team2_seed: team2_seed,
        	winning_nba_team_id: nil, total_games: nil)
        matchupct += 1
      end
    end
    puts "Imported " + matchupct.to_s + " NBA matchups for " + year.to_s + "!"
  end

  desc "Imports NBA playoff bet data from CSV file"
  task :playoff_bets => :environment do
    require 'csv'
    betcount = 0
    year = Date.today.year
    CSV.foreach(File.join(
    	File.expand_path(::Rails.root), "/lib/assets/nba_playoff_bets.csv")) do |row|
      email = row[0]
      round = row[1].to_i
      position = row[2].to_i
      team_abbreviation = row[3]
      games = row[4].to_i
      user = User.where(email: email).first
      team = NbaTeam.where(abbreviation: team_abbreviation).first
      if !team.nil? && !user.nil?
      	bet = NbaPlayoffBet.create(year: year, round: round, position: position,
            expected_total_games: games)
      	bet.update_attribute(:expected_nba_team_id, team.id)
      	bet.update_attribute(:user_id, user.id)
        betcount += 1
      end
    end
    puts "Imported " + betcount.to_s + " NBA bets for " + year.to_s + "!"
  end
end