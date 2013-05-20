module NbaPlayoffBetsHelper

  # Returns the matchup in the specified round and position
  def matchupAtPosition(round, position, title)
    matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                               .first
    # TODO check result and indicate if user was correct
    matchupRow = "<strong>" + title + "</strong><br/>" + 
                 matchup.team1_seed.to_s + ". " + matchup.nba_team1.city + "<br/>" +
                 matchup.team2_seed.to_s + ". " + matchup.nba_team2.city
    return matchupRow.html_safe
  end

  # Returns the select tag with team and number of games for the specified round & position.
  def selectAtRoundPosition(round, position)
  	matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                               .first

    # TODO matchup will be used to mark whether user was correct

    betForMatchup = NbaPlayoffBet.includes(:nba_playoff_matchup)
                                 .where("nba_playoff_bets.year = " + @currentYear.to_s + 
                               	      " and nba_playoff_bets.user_id = " + current_user.id.to_s +
                               	      " and nba_playoff_matchups.round = " + round.to_s +
                               	      " and nba_playoff_matchups.position = " + position.to_s)
    
    if round == 1
      # use matchup to generate select tag
      return generateSelect(round, position, matchup.team1_seed, matchup.nba_team1,
          matchup.team2_seed, matchup.nba_team2)
    else
      # get bets from previous round
      pos1 = (position * 2) - 1
      pos2 = (position * 2)
      prevRoundBets = 
          NbaPlayoffBet.includes(:nba_playoff_matchup)
                       .where("nba_playoff_bets.year = " + @currentYear.to_s + 
                         " and nba_playoff_bets.user_id = " + current_user.id.to_s +
                         " and nba_playoff_matchups.round = " + (round - 1).to_s +
                         " and nba_playoff_matchups.position in (" + 
                         	pos1.to_s + "," + pos2.to_s + ")")
      
      if prevRoundBets.size == 2
        # 2 bets in previous round indicates this select can be shown
        # TODO figure out seed
        return generateSelect(round, position,
        	1, prevRoundBets.first.expected_nba_team,
        	2, prevRoundBets.last.expected_nba_team)
      end
      
      # previous round bets aren't complete yet; show nothing.
      return ""
    end
  end

  # 
  # TODO pass in betForMatchup to indicate what user has selected already
  def generateSelect(round, position, team1_seed, nba_team1, team2_seed, nba_team2)
    selectTag = "<select name='nba_" + round.to_s + "_" + position.to_s + "' class='input-tourney'>
                   <option value='0'>--</option>"
    for games in [4,5,6,7]
      selectTag += "<option value='" + nba_team1.id.to_s + ":" + games.to_s + "'>" + team1_seed.to_s + 
                    ". " + nba_team1.city + 
                    " in " + games.to_s + "</option>"
    end
    for games in [4,5,6,7]
      selectTag += "<option value='" + nba_team2.id.to_s + ":" + games.to_s + "'>" + team2_seed.to_s + 
                    ". " + nba_team2.city +
                    " in " + games.to_s + "</option>"
    end
    selectTag += "</select>"
    return selectTag.html_safe
  end

  # TODO show in read-only mode after playoffs begin
end
