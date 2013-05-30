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

    betForMatchup = NbaPlayoffBet.where(user_id: current_user.id,
                                        year: @currentYear,
                                        round: round,
                                        position: position).first
    
    if round == 1
      # use matchup to generate select tag
      return generateSelect(round, position, matchup.team1_seed, matchup.nba_team1,
          matchup.team2_seed, matchup.nba_team2, betForMatchup)
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
        # TODO figure out seed
        return generateSelect(round, position,
        	1, prevRoundBets[0].expected_nba_team,
        	2, prevRoundBets[1].expected_nba_team, betForMatchup)
      end
      
      # previous round bets aren't complete yet; show nothing.
      return ""
    end
  end

  # Returns a select tag for the specified round/team/teams, marking the selected value according to
  # the existing bet.
  def generateSelect(round, position, team1_seed, nba_team1, team2_seed, nba_team2, existingBet)
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
      selectTag += ">" + team1_seed.to_s + ". " + nba_team1.city + " in " + games.to_s + "</option>"
    }
    4.upto(7) { |games|
      selectTag += "<option value='" + nba_team2.id.to_s + ":" + games.to_s + "'"
      if (!existingBet.nil? && (existingBet.expected_nba_team_id == nba_team2.id) &&
          (existingBet.expected_total_games == games))
        selectTag += " selected"
      end
      selectTag += ">" + team2_seed.to_s + ". " + nba_team2.city + " in " + games.to_s + "</option>"
    }
    selectTag += "</select>"
    return selectTag.html_safe
  end

  # TODO show in read-only mode after playoffs begin
end
