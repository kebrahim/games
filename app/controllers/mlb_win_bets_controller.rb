class MlbWinBetsController < ApplicationController
  # GET /mlb_win_bets
  # GET /mlb_win_bets.json
  def index
    # get all existing bets
    @logged_in_user = getLoggedInUser
    @mlb_win_bets = MlbWinBet.includes(:mlb_win).where(user_id: @logged_in_user).order("amount DESC")
    
    # pull all mlb over/unders which have not been assigned by the logged-in user for the current
    # year, separated by division
    current_year = Date.today.year
    @nl_east = division_query(@logged_in_user.id, current_year, "NL", "East")
    @nl_central = division_query(@logged_in_user.id, current_year, "NL", "Central")
    @nl_west = division_query(@logged_in_user.id, current_year, "NL", "West")
    @al_east = division_query(@logged_in_user.id, current_year, "AL", "East")
    @al_central = division_query(@logged_in_user.id, current_year, "AL", "Central")
    @al_west = division_query(@logged_in_user.id, current_year, "AL", "West")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_win_bets }
    end
  end

  # Returns a query to MlbWins to return all of the over/unders, belonging to the specified league
  # and division, which have NOT been bet on by the specified user during the specified year.
  def division_query(user_id, year, league, division)
    return MlbWin.joins("LEFT OUTER JOIN mlb_win_bets ON mlb_wins.id = mlb_win_bets.mlb_win_id")
        .joins("LEFT OUTER JOIN users ON mlb_win_bets.user_id = users.id")
        .where("(mlb_win_bets.user_id is null or mlb_win_bets.user_id <> " + 
            user_id.to_s + ") and mlb_wins.year = " + year.to_s)
        .joins(:mlb_team).where("mlb_teams.league = '" + league + "' and mlb_teams.division = '" +
            division + "'")
        .order("line DESC")
  end
  
  def bulksave
    if params["cancel"].nil?
      # get existing bets by user
      logged_in_user = getLoggedInUser
      existing_bets = MlbWinBet.includes(:mlb_win).where(user_id: logged_in_user)
      current_year = Date.today.year
      new_over_unders =
          MlbWin.joins("LEFT OUTER JOIN mlb_win_bets ON mlb_wins.id = mlb_win_bets.mlb_win_id")
          .joins("LEFT OUTER JOIN users ON mlb_win_bets.user_id = users.id")
          .where("(mlb_win_bets.user_id is null or mlb_win_bets.user_id <> " + 
              logged_in_user.id.to_s + ") and mlb_wins.year = " + current_year.to_s)
      
      # get total number of bets
      new_bet_count = 0
      new_over_unders.each do |new_over_under|
        predictionKey = "prediction" + new_over_under.id.to_s
        amountKey = "amount" + new_over_under.id.to_s
        if (!getBetName(params[predictionKey]).empty? && params[amountKey] != "0")
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
          if getBetName(params[predictionKey]) != existing_bet.prediction
            existing_bet.update_attribute(:prediction, getBetName(params[predictionKey]))  
          end
          # TODO combine changed attributes into one call to update_attribute
        end
     
        # create new o/u bets
        new_over_unders.each do |new_over_under|
          predictionKey = "prediction" + new_over_under.id.to_s
          amountKey = "amount" + new_over_under.id.to_s
          if (!getBetName(params[predictionKey]).empty? && params[amountKey] != "0")
            new_bet = MlbWinBet.new
            new_bet.mlb_win_id = new_over_under.id
            new_bet.user_id = logged_in_user.id
            new_bet.prediction = getBetName(params[predictionKey])
            new_bet.amount = params[amountKey].to_i
            new_bet.save
          end
        end
        confirmationMessage = "Over/unders updated!"
      end
    end
    
    # redirect to index.html w/ confirmation message
    redirect_to mlb_win_bets_path, notice: confirmationMessage
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
  
  def getLoggedInUser
    # TODO determine logged-in user
    return User.first 
  end
  
  # TODO move to model
  def getBetName(betId)
    if betId == "1"
      return "Over"
    elsif betId == "2"
      return "Under"
    else
      return ""
    end
  end
end
