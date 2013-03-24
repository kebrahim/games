class MlbWinBetsController < ApplicationController
  # GET /mlb_win_bets
  # GET /mlb_win_bets.json
  def index
    @mlb_win_bets = MlbWinBet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_win_bets }
    end
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
