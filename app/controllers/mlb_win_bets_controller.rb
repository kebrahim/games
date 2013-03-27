class MlbWinBetsController < ApplicationController
  # GET /mlb_win_bets
  # GET /mlb_win_bets.json
  def index
    # TODO determine logged-in user
    @logged_in_user = User.last
    @mlb_win_bets = MlbWinBet.where(user_id: @logged_in_user)
    
    # TODO calculate current year
    # pull all mlb over/unders which have not been assigned by the logged-in user for the current
    # year, separated by division
    @nl_east = division_query(@logged_in_user.id, 2013, "NL", "East")
    @nl_central = division_query(@logged_in_user.id, 2013, "NL", "Central")
    @nl_west = division_query(@logged_in_user.id, 2013, "NL", "West")
    @al_east = division_query(@logged_in_user.id, 2013, "AL", "East")
    @al_central = division_query(@logged_in_user.id, 2013, "AL", "Central")
    @al_west = division_query(@logged_in_user.id, 2013, "AL", "West")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_win_bets }
    end
  end

  #
  def division_query(user_id, year, league, division)
    return MlbWin.joins("LEFT OUTER JOIN mlb_win_bets ON mlb_wins.id = mlb_win_bets.mlb_win_id")
        .joins("LEFT OUTER JOIN users ON mlb_win_bets.user_id = users.id")
        .where("(mlb_win_bets.user_id is null or mlb_win_bets.user_id <> " + 
            user_id.to_s + ") and mlb_wins.year = " + year.to_s)
        .joins(:mlb_team).where("mlb_teams.league = '" + league + "' and mlb_teams.division = '" +
            division + "'")
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
end
