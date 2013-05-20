class NbaPlayoffBetsController < ApplicationController
  # GET /nba_playoff_bets
  # GET /nba_playoff_bets.json
  def index
    @user = current_user
    if !@user.nil?
      @currentYear = Date.today.year
      @nba_playoff_bets = NbaPlayoffBet.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @nba_playoff_bets }
      end
    else
      redirect_to root_url
    end
  end

  # GET /nbaPlayoffs
  def allusers
    @user = current_user
    if !@user.nil?
      @currentYear = Date.today.year
    else
      redirect_to root_url
    end
  end

  # GET /nba_playoff_bets/1
  # GET /nba_playoff_bets/1.json
  def show
    @nba_playoff_bet = NbaPlayoffBet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nba_playoff_bet }
    end
  end

  # GET /nba_playoff_bets/new
  # GET /nba_playoff_bets/new.json
  def new
    @nba_playoff_bet = NbaPlayoffBet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nba_playoff_bet }
    end
  end

  # GET /nba_playoff_bets/1/edit
  def edit
    @nba_playoff_bet = NbaPlayoffBet.find(params[:id])
  end

  # POST /nba_playoff_bets
  # POST /nba_playoff_bets.json
  def create
    @nba_playoff_bet = NbaPlayoffBet.new(params[:nba_playoff_bet])

    respond_to do |format|
      if @nba_playoff_bet.save
        format.html { redirect_to @nba_playoff_bet, notice: 'Nba playoff bet was successfully created.' }
        format.json { render json: @nba_playoff_bet, status: :created, location: @nba_playoff_bet }
      else
        format.html { render action: "new" }
        format.json { render json: @nba_playoff_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nba_playoff_bets/1
  # PUT /nba_playoff_bets/1.json
  def update
    @nba_playoff_bet = NbaPlayoffBet.find(params[:id])

    respond_to do |format|
      if @nba_playoff_bet.update_attributes(params[:nba_playoff_bet])
        format.html { redirect_to @nba_playoff_bet, notice: 'Nba playoff bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nba_playoff_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nba_playoff_bets/1
  # DELETE /nba_playoff_bets/1.json
  def destroy
    @nba_playoff_bet = NbaPlayoffBet.find(params[:id])
    @nba_playoff_bet.destroy

    respond_to do |format|
      format.html { redirect_to nba_playoff_bets_url }
      format.json { head :no_content }
    end
  end
end
