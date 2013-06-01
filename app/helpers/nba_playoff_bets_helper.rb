module NbaPlayoffBetsHelper

  # Returns the matchup in the specified round and position
  def matchupAtPosition(round, position, title)
    matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                               .first
    
    if matchup.nil?
      matchupRow = "<strong>" + title + "</strong><br/>"
    else
      matchupRow = "<strong>" + title + "</strong><br/>" + 
          matchup.team1_seed.to_s + ". " + matchup.nba_team1.city + "<br/>" +
          matchup.team2_seed.to_s + ". " + matchup.nba_team2.city
    end
    return matchupRow.html_safe
  end

  # Returns the winner of the matchup at the specified position
  def winnerAtMatchupPosition(round, position, title)
    matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                               .first
    if matchup.nil?
      matchupRow = "<strong>" + title + "</strong><br/>"
    else
      matchupRow = "<strong>" + title + "</strong><br/>" +
          matchup.winning_nba_team.city + " " + matchup.winning_nba_team.name + "<br/> (" + 
          matchup.total_games.to_s + " games)"
    end
    return matchupRow.html_safe    
  end

  # Returns the select tag with team and number of games for the specified round & position.
  def selectAtRoundPosition(round, position)
  	matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                               .first

    betForMatchup = NbaPlayoffBet.where(user_id: current_user.id,
                                        year: @currentYear,
                                        round: round,
                                        position: position).first
    
    if round == 1
      # use matchup to generate select tag
      return generateSelect(round, position, matchup.nba_team1, matchup.nba_team2, betForMatchup)
    else
      # get bets from previous round
      positions = [((position * 2) - 1), (position * 2)]
      prevRoundBets = 
          NbaPlayoffBet.where("user_id = " + current_user.id.to_s + " and 
                              year = " + @currentYear.to_s + " and 
                              round = " + (round - 1).to_s + " and 
                              position IN (?)", positions)
      
      if prevRoundBets.size == 2
        # 2 bets in previous round indicates this select can be shown
        return generateSelect(round, position, prevRoundBets[0].expected_nba_team,
        	  prevRoundBets[1].expected_nba_team, betForMatchup)
      end
      
      # previous round bets aren't complete yet; show nothing.
      return ""
    end
  end

  # Returns a select tag for the specified round/team/teams, marking the selected value according to
  # the existing bet.
  def generateSelect(round, position, nba_team1, nba_team2, existingBet)
    selectTag = "<select name='nba_" + round.to_s + "_" + position.to_s + "' class='input-tourney'>
                   <option value='0'"
    if existingBet.nil?
      selectTag += " selected"
    end
    selectTag += ">--</option>"
    4.upto(7) { |games|
      selectTag += "<option value='" + nba_team1.id.to_s + ":" + games.to_s + "'"
      if (!existingBet.nil? && (existingBet.expected_nba_team_id == nba_team1.id) && 
          (existingBet.expected_total_games == games))
        selectTag += " selected"
      end
      selectTag += ">" + nba_team1.abbreviation + " in " + games.to_s + "</option>"
    }
    4.upto(7) { |games|
      selectTag += "<option value='" + nba_team2.id.to_s + ":" + games.to_s + "'"
      if (!existingBet.nil? && (existingBet.expected_nba_team_id == nba_team2.id) &&
          (existingBet.expected_total_games == games))
        selectTag += " selected"
      end
      selectTag += ">" + nba_team2.abbreviation + " in " + games.to_s + "</option>"
    }
    selectTag += "</select>"
    return selectTag.html_safe
  end

  # Returns a string with the expected team and number of games for the logged-in user, during the
  # current year, for the specified round & position.
  def readOnlyBetAtRoundPosition(round, position)
    return readOnlyBetAtRoundPositionForUser(round, position, current_user)
  end

  # Returns a string with the expected team and number of games for the specified user, during the
  # current year, for the specified round & position.
  def readOnlyBetAtRoundPositionForUser(round, position, user)
    betForMatchup = NbaPlayoffBet.where(user_id: user.id,
                                        year: @currentYear,
                                        round: round,
                                        position: position).first
    
    if !betForMatchup.nil?
      # TODO matchup will be used to mark whether user was correct
      matchup = NbaPlayoffMatchup.where(year: @currentYear, round: round, position: position)
                                 .first
      return (betForMatchup.expected_nba_team.abbreviation + " in " + 
          betForMatchup.expected_total_games.to_s).html_safe
    else      
      # no bet yet; show nothing
      return ""
    end
  end
end
