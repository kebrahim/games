class NbaPlayoffBetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
      # TODO betsEditable depends on schedule
      @betsEditable = true

      # Get all users which have made NBA Playoff picks, ordered by score DESC
      @usersToPoints = NbaPlayoffBet.where(year: @currentYear)
                                    .group(:user_id)
                                    .sum(:points)
      @userMap = buildUserMap(@currentYear)
      @finalsPicksMap = buildFinalsPicksMap(@currentYear)
    else
      redirect_to root_url
    end
  end

  # Returns a map of user id to NBA Playoff user
  def buildUserMap(currentYear)
    nbaPlayoffUsers = NbaPlayoffBet.includes(:user)
                                   .where(year: currentYear)
                                   .select("DISTINCT user_id")
    userMap = {}
    nbaPlayoffUsers.each do |nbaPlayoffUser|
      userMap[nbaPlayoffUser.user.id] = nbaPlayoffUser.user
    end
    return userMap
  end

  # Returns a map of user id to NBA Playoff finals pick
  def buildFinalsPicksMap(currentYear)
    finalsBets = NbaPlayoffBet.where(year: currentYear)
                              .where(round: 4)
    finalsPicksMap = {}
    finalsBets.each do |finalsBet|
      finalsPicksMap[finalsBet.user_id] = finalsBet
    end
    return finalsPicksMap
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

  # POST /nba_playoff_bets_save
  def bulksave
    logged_in_user = current_user
    if logged_in_user.nil?
      redirect_to root_url
    elsif params["cancel"].nil?
      current_year = Date.today.year

      # iterate through round/position, checking if new or existing bet should be created/updated
      1.upto(4) { |round|
        maxPosition = 2 ** (4 - round)
        1.upto(maxPosition) { |position|
          betKey = "nba_" + round.to_s + "_" + position.to_s
          if (!params[betKey].nil?)
            # get existing bet from db
            existingBet = NbaPlayoffBet.where(user_id: logged_in_user.id,
                                              year: current_year,
                                              round: round,
                                              position: position).first
            if (params[betKey] != "0")
              # convert from selected value to team and number of games
              team_games = params[betKey].split(":")
              team_id = team_games[0].to_i
              games = team_games[1].to_i
  
              if !existingBet.nil?
                # if bet exists, update
                if existingBet.expected_nba_team_id != team_id
                  existingBet.update_attribute(:expected_nba_team_id, team_id)
                end
                if existingBet.expected_total_games != games
                  existingBet.update_attribute(:expected_total_games, games)
                end
              else
                # otherwise, create new bet
                new_bet = NbaPlayoffBet.new
                new_bet.user_id = logged_in_user.id
                new_bet.year = current_year
                new_bet.round = round
                new_bet.position = position
                new_bet.expected_nba_team_id = team_id
                new_bet.expected_total_games = games
                new_bet.points = 0
                new_bet.save
              end
            elsif !existingBet.nil?
              # existing bet exists & params is 0, so delete
              existingBet.destroy
            end
          end
        }
      }

      # redirect to index.html w/ confirmation message
      confirmationMessage = "NBA playoff picks updated!"
      redirect_to "/nbaPlayoffBets", notice: confirmationMessage
    else
      # Cancel resets page.
      redirect_to "/nbaPlayoffBets"
    end
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
