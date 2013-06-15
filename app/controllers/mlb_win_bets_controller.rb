class MlbWinBetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /mlb_win_bets
  # GET /mlb_win_bets.json
  def index
    # get all existing bets
    @logged_in_user = getLoggedInUser
    if !@logged_in_user.nil?
      @mlb_win_bets =
          MlbWinBet.includes(:mlb_win)
                   .where(user_id: @logged_in_user)
                   .order("amount DESC")
    
      # pull all mlb over/unders which have not been assigned by the logged-in user for the current
      # year, separated by division
      @nl_east = availableWinsByDivision(@logged_in_user.id, "NL", "East")
      @nl_central = availableWinsByDivision(@logged_in_user.id, "NL", "Central")
      @nl_west = availableWinsByDivision(@logged_in_user.id, "NL", "West")
      @al_east = availableWinsByDivision(@logged_in_user.id, "AL", "East")
      @al_central = availableWinsByDivision(@logged_in_user.id, "AL", "Central")
      @al_west = availableWinsByDivision(@logged_in_user.id, "AL", "West")
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @mlb_win_bets }
      end
    else
      redirect_to root_url
    end
  end

  # POST /mlb_win_bets_save
  def bulksave
    if params["cancel"].nil?
      logged_in_user = getLoggedInUser
      current_year = Date.today.year

      # get existing bets by user
      existing_bets =
          MlbWinBet.includes(:mlb_win)
                   .where("user_id = " + logged_in_user.id.to_s + 
                          " and mlb_wins.year = " + current_year.to_s)

      # get potential new bets
      newOverUnders = availableWins(logged_in_user.id)
      
      # get total number of bets
      new_bet_count = 0
      newOverUnders.each do |new_over_under|
        predictionKey = "prediction" + new_over_under.id.to_s
        amountKey = "amount" + new_over_under.id.to_s
        if (!MlbWinBet.predictionName(params[predictionKey]).empty? && params[amountKey] != "0")
          new_bet_count += 1
        end
      end

      # if total bets > 10, don't save & show error
      if ((existing_bets.count + new_bet_count) > 10)
        confirmationMessage = "Error: Too many bets!"
      else
        # update attributes of existing bets
        existing_bets.each do |existing_bet|
          amountKey = "amount" + existing_bet.mlb_win_id.to_s
          if params[amountKey] != existing_bet.amount
            existing_bet.update_attribute(:amount, params[amountKey])
          end
      
          predictionKey = "prediction" + existing_bet.mlb_win_id.to_s
          if MlbWinBet.predictionName(params[predictionKey]) != existing_bet.prediction
            existing_bet.update_attribute(
                :prediction, MlbWinBet.predictionName(params[predictionKey]))  
          end
          # TODO combine changed attributes into one call to update_attribute
        end
     
        # create new o/u bets
        newOverUnders.each do |new_over_under|
          predictionKey = "prediction" + new_over_under.id.to_s
          amountKey = "amount" + new_over_under.id.to_s
          if (!MlbWinBet.predictionName(params[predictionKey]).empty? && params[amountKey] != "0")
            new_bet = MlbWinBet.new
            new_bet.mlb_win_id = new_over_under.id
            new_bet.user_id = logged_in_user.id
            new_bet.prediction = MlbWinBet.predictionName(params[predictionKey])
            new_bet.amount = params[amountKey].to_i
            new_bet.save
          end
        end
        confirmationMessage = "Over/unders updated!"
      end
    end
    
    # redirect to index.html w/ confirmation message
    redirect_to "/mlbOverUnderBets", notice: confirmationMessage
  end
  
  # GET /mlbOverUnders
  def allusers
    @user = getLoggedInUser
    if !@user.nil?
      @currentYear = Date.today.year
    
      # show bets for logged-in user
      @userBets =
          MlbWinBet.joins(:mlb_win)
                   .where("mlb_wins.year = " + @currentYear.to_s)
                   .where("user_id = " + @user.id.to_s)
                   .order("amount DESC")

      # TODO user can only change bets during certain window
      @betsEditable = false

      # show expected winning bets, based on current standings    
      lastStanding = MlbStanding.where(year: @currentYear).order(:updated_at).last
      if !lastStanding.updated_at.today? || (lastStanding.wins == 0 && lastStanding.losses == 0)
        # if DB is not updated, pull standings data from internet
        standingsHash = JSON.parse(Curl.get("https://erikberg.com/mlb/standings.json").body_str)
        @teamToStandingsMap = populateStandingsInDB(standingsHash["standing"], @currentYear)
        @standingsDate = DateTime.strptime(standingsHash["standings_date"]).strftime("%m/%d/%y")
      else
        # otherwise, pull standings data from DB
        @teamToStandingsMap = buildTeamToStandingsMap(@currentYear)
        @standingsDate = lastStanding.updated_at.strftime("%m/%d/%y")
      end

      @divisionToStandingsMap = buildDivisionToStandingsMap(@teamToStandingsMap)
      @teamToWinMap = buildTeamToWinMap(@currentYear)

      # show all bets for all users
      @allBets =
          MlbWinBet.joins(:mlb_win).joins(:mlb_team)
                   .where("mlb_wins.year = " + @currentYear.to_s)
                   .order(:user_id, "amount DESC")
      @userToBetsMap = buildUserToBetsMap(@currentYear, @teamToStandingsMap)

      respond_to do |format|
        format.html # all.html.erb
      end
    else
      redirect_to root_url
    end
  end

  # builds a map from mlb league/division to an array of MLB standings within that division
  def buildDivisionToStandingsMap(teamToStandingsMap)
    divisionToStandingsMap = {}
    teamToStandingsMap.keys.each do |team_id|
      standing = teamToStandingsMap[team_id]
      team = standing.mlb_team
      if !divisionToStandingsMap.has_key?(team.league + team.division)
        divisionToStandingsMap[team.league + team.division] = [standing]
      else
        divisionToStandingsMap[team.league + team.division] << standing
      end
    end
    return divisionToStandingsMap
  end

  # returns a map of mlb team id to the o/u line for the specified year
  def buildTeamToWinMap(year)
    teamToWinMap = {}
    MlbWin.where(year: year).each do |win|
      teamToWinMap[win.mlb_team_id] = win
    end
    return teamToWinMap
  end

  # Creates and returns a hashmap of user-id to a second hashmap of user data, mapping "bets" to an
  # array of all of their bets for the specified year, "points" to the total number of points they
  # would score if the season ended today, and "user" to the actual user object.
  def buildUserToBetsMap(year, teamToStandingsMap)
    allBets = MlbWinBet.joins(:mlb_win)
                       .where("mlb_wins.year = " + year.to_s)
                       .order(:user_id, "amount DESC")
    userToBets = {}
    allBets.each do |bet|
      if !userToBets.has_key?(bet.user.id)
        # hash doesn't have user yet; initialize user data hash
        userData = {}
        userData["bets"] = [bet]
        userData["points"] = 0
        userData["user"] = bet.user
        userToBets[bet.user.id] = userData
      else
        # add bet to user data hash
        userToBets[bet.user.id]["bets"] << bet
      end

      # Update points if bet is correct, based on projection of current standings
      mlb_standing = teamToStandingsMap[bet.mlb_win.mlb_team_id]
      if mlb_standing.projected_result(bet.mlb_win.line) == bet.prediction
        userToBets[bet.user.id]["points"] += bet.amount
      end
    end
    return userToBets
  end

  # Updates the MLB standing information in the database for the specified year, based on the
  # specified JSON data, and returns a map of mlb team id to MLB standing for specified year.
  def populateStandingsInDB(standingsJSON, year)
    teamToStandingsMap = {}
    teamNameToStandingMap = buildMlbTeamNameToStandingMap(year)
    standingsJSON.each do |standing|
      mlbStanding = teamNameToStandingMap[standing["last_name"]]
      if !mlbStanding.nil?
        mlbStanding.update_attributes({wins: standing["won"], losses: standing["lost"]})
        teamToStandingsMap[mlbStanding.mlb_team_id] = mlbStanding
      end
    end
    return teamToStandingsMap
  end

  # Returns a map of MLB team name to the entire team
  def buildMlbTeamNameToStandingMap(year)
    teamNameToStandingMap = {}
    MlbStanding.includes(:mlb_team).where(year: year).each do |mlb_standing|
      teamNameToStandingMap[mlb_standing.mlb_team.name] = mlb_standing
    end
    return teamNameToStandingMap
  end

  # Build map of mlb team id to MLB standing from the database
  def buildTeamToStandingsMap(year)
    teamToStandingsMap = {}

    MlbStanding.where(year: year).each do |mlbStanding|
      teamToStandingsMap[mlbStanding.mlb_team_id] = mlbStanding
    end
    return teamToStandingsMap
  end

  # GET /mlb_win_bets/1
  # GET /mlb_win_bets/1.json
  def show
    @mlb_win_bet = MlbWinBet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mlb_win_bet }
    end
  end

  # GET /mlb_win_bets/new
  # GET /mlb_win_bets/new.json
  def new
    @mlb_win_bet = MlbWinBet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mlb_win_bet }
    end
  end

  # GET /mlb_win_bets/1/edit
  def edit
    @mlb_win_bet = MlbWinBet.find(params[:id])
  end

  # POST /mlb_win_bets
  # POST /mlb_win_bets.json
  def create
    @mlb_win_bet = MlbWinBet.new(params[:mlb_win_bet])

    respond_to do |format|
      if @mlb_win_bet.save
        format.html { redirect_to @mlb_win_bet, notice: 'Mlb win bet was successfully created.' }
        format.json { render json: @mlb_win_bet, status: :created, location: @mlb_win_bet }
      else
        format.html { render action: "new" }
        format.json { render json: @mlb_win_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mlb_win_bets/1
  # PUT /mlb_win_bets/1.json
  def update
    @mlb_win_bet = MlbWinBet.find(params[:id])

    respond_to do |format|
      if @mlb_win_bet.update_attributes(params[:mlb_win_bet])
        format.html { redirect_to @mlb_win_bet, notice: 'Mlb win bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mlb_win_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlb_win_bets/1
  # DELETE /mlb_win_bets/1.json
  def destroy
    @mlb_win_bet = MlbWinBet.find(params[:id])
    @mlb_win_bet.destroy

    respond_to do |format|
      format.html { redirect_to mlb_win_bets_url }
      format.json { head :no_content }
    end
  end
  
  # Returns the currently logged in user
  def getLoggedInUser
    if session[:user_id]
      return User.find(session[:user_id])
    else
      return nil
    end
  end

  # Returns all of the over/unders which have NOT been bet on by the specified user in the current
  # year.
  def availableWins(userId)
    return availableWinsByDivision(userId, nil, nil)
  end

  # Returns all of the over/unders for teams belonging to the specified league and division, which
  # have NOT been bet on by the specified user in the current year.
  def availableWinsByDivision(userId, league, division)
    year = Date.today.year

    # get all teams that have been bet on by the specified user in the current year
    teamFilter =
        MlbWin.joins(:mlb_win_bets)
              .where("year = " + year.to_s + " and user_id = " + userId.to_s)
              .select(:mlb_team_id).to_sql

    # get all over/unders which not been bet on in the current year
    availableWinsQuery =
        MlbWin.joins(:mlb_team)
              .where(year: year)
              .where("mlb_teams.id not in (#{teamFilter})")

    # filter by league, if specified
    if !league.nil?
      availableWinsQuery = availableWinsQuery.where("mlb_teams.league = '" + league + "'")
    end

    # filter by division, if specified
    if !division.nil?
      availableWinsQuery = availableWinsQuery.where("mlb_teams.division = '" + division + "'")
    end

    # sort by over/under line
    return availableWinsQuery.order("line DESC")
  end
end
