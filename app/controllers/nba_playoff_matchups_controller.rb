class NbaPlayoffMatchupsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /nba_playoff_matchups
  # GET /nba_playoff_matchups.json
  def index
    # TODO confirm logged-in user is admin
    @currentYear = Date.today.year
    @nba_playoff_scores = NbaPlayoffScore.order(:round)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # returns the nba playoff matchups filtered by year & round
  def getMatchupsByRound(year, round)
    return NbaPlayoffMatchup.includes(:nba_team1)
                            .includes(:nba_team2)
                            .includes(:winning_team)
                            .where(year: year, round: round)
                            .order(:position)
  end

  # GET /nba_playoff_matchups/1
  # GET /nba_playoff_matchups/1.json
  def show
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nba_playoff_matchup }
    end
  end

  # GET /nba_playoff_matchups/new
  # GET /nba_playoff_matchups/new.json
  def new
    @nba_playoff_matchup = NbaPlayoffMatchup.new
    @nba_teams = getNbaTeams()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nba_playoff_matchup }
    end
  end

  # GET /nba_playoff_matchups/1/edit
  def edit
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
    @nba_teams = getNbaTeams
  end

  # POST /nba_playoff_matchups
  # POST /nba_playoff_matchups.json
  def create
    @nba_playoff_matchup = NbaPlayoffMatchup.new(params[:nba_playoff_matchup])
    @nba_playoff_matchup.nba_team1_id = params[:nba_team1_id]
    @nba_playoff_matchup.nba_team2_id = params[:nba_team2_id]

    respond_to do |format|
      if @nba_playoff_matchup.save
        format.html { redirect_to @nba_playoff_matchup, notice: 'Nba playoff matchup was successfully created.' }
        format.json { render json: @nba_playoff_matchup, status: :created, location: @nba_playoff_matchup }
      else
        @nba_teams = getNbaTeams()
        format.html { render action: "new" }
        format.json { render json: @nba_playoff_matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nba_playoff_matchups/1
  # PUT /nba_playoff_matchups/1.json
  def update
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
    @nba_playoff_matchup.nba_team1_id = params[:nba_team1_id]
    @nba_playoff_matchup.nba_team2_id = params[:nba_team2_id]

    respond_to do |format|
      if @nba_playoff_matchup.update_attributes(params[:nba_playoff_matchup])
        format.html { redirect_to @nba_playoff_matchup, 
                      notice: 'NBA playoff matchup was successfully updated.' }
        format.json { head :no_content }
      else
        @nba_teams = getNbaTeams()
        format.html { render action: "edit" }
        format.json { render json: @nba_playoff_matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /nba_playoff_matchups/1/winner
  def setwinner
    # TODO confirm logged-in user is admin
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
    team_ids = [@nba_playoff_matchup.nba_team1_id, @nba_playoff_matchup.nba_team2_id]
    @nba_teams = NbaTeam.where("id in (?)", team_ids)
  end

  # returns a map of scoring round to points
  def buildScoringRoundToPointsMap
    scoringMap = {}
    allScores = NbaPlayoffScore.all
    allScores.each do |score|
      scoringMap[score.round] = score.points
    end
    return scoringMap
  end

  # POST /nba_playoff_matchups/1/winner
  def updatewinner
    # TODO confirm logged-in user is admin
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params["nba_matchup_id"])
    if (params["winning_team_id"] != @nba_playoff_matchup.winning_nba_team_id)
      @nba_playoff_matchup.winning_nba_team_id = params["winning_team_id"].to_i      
    end
    if (params["total_games"] != @nba_playoff_matchup.total_games)
      @nba_playoff_matchup.total_games = params["total_games"].to_i      
    end

    foundError = false
    if !@nba_playoff_matchup.hasWinner
      showError(@nba_playoff_matchup.id, "Please select winner and total games")
    elsif @nba_playoff_matchup.save
      # Update standings.
      nbaBets = NbaPlayoffBet.where(year: @nba_playoff_matchup.year)
                             .where(round: @nba_playoff_matchup.round)
                             .where(position: @nba_playoff_matchup.position)
      roundToPointsMap = buildScoringRoundToPointsMap
      nbaBets.each do |nbaBet|
        # bet is only correct if team matches
        if nbaBet.expected_nba_team_id == @nba_playoff_matchup.winning_nba_team_id
          totalPoints = roundToPointsMap[@nba_playoff_matchup.round]
          # if total games prediction is correct, add bonus
          if nbaBet.expected_total_games == @nba_playoff_matchup.total_games
            totalPoints += roundToPointsMap[NbaPlayoffScore::BONUS_GAMES_ROUND]
          end
          # update points attribute of bet
          nbaBet.update_attribute(:points, totalPoints)
        end
      end

      # Create new matchup after first team wins; update existing matchup if 2nd team wins
      partner_position = @nba_playoff_matchup.position.odd? ?
          (@nba_playoff_matchup.position + 1) : (@nba_playoff_matchup.position - 1)
      partner_matchup = NbaPlayoffMatchup.where(year: @nba_playoff_matchup.year,
                                                round: @nba_playoff_matchup.round, 
                                                position: partner_position).first
      if !partner_matchup.nil? 
        next_position = (@nba_playoff_matchup.position + partner_matchup.position + 1) / 4
        next_matchup = NbaPlayoffMatchup.where(year: @nba_playoff_matchup.year,
                                               round: (@nba_playoff_matchup.round + 1),
                                               position: next_position).first
        if !partner_matchup.hasWinner
          # only this matchup has been decided, create/update next_matchup
          if next_matchup.nil?
            # next round matchup doesn't exist; create it
            next_matchup = NbaPlayoffMatchup.new()
            next_matchup.year = @nba_playoff_matchup.year
            next_matchup.position = next_position
            next_matchup.round = @nba_playoff_matchup.round + 1
          end

          updateNextRoundMatchupTeamAndSeed(next_matchup, @nba_playoff_matchup)
          if !next_matchup.save
            showError(@nba_playoff_matchup.id, "Problem occurred while saving next round matchup")
            foundError = true;
          end
        elsif !next_matchup.nil?
          # both matchups have been decided; update next_matchup
          updateNextRoundMatchupTeamAndSeed(next_matchup, @nba_playoff_matchup)
          if !next_matchup.save
            showError(@nba_playoff_matchup.id, "Problem occurred while saving next round matchup")
            foundError = true;
          end
        else
          showError(@nba_playoff_matchup.id, "Missing next round matchup to save")
          foundError = true;
        end
      elsif @nba_playoff_matchup.round != 4
        # A partner matchup should exist, except for the final round.
        showError(@nba_playoff_matchup.id, "Missing partner matchup")
        foundError = true;
      end
      
      # redirect to index.html w/ confirmation message
      if !foundError
        redirect_to '/nba_playoff_matchups', notice: 'NBA Winner Saved!'
      end
    else
      # redirect to set winner page w/ error message
      showError(@nba_playoff_matchup.id, "Problem occurred while saving matchup")
    end
  end

  # Updates the team and seed of the specified matchup in the next round, based on the winning team
  # in the specified current matchup.
  def updateNextRoundMatchupTeamAndSeed(nextRoundMatchup, currentMatchup)
    if currentMatchup.position.odd?
      nextRoundMatchup.nba_team1_id = currentMatchup.winning_nba_team_id
      nextRoundMatchup.team1_seed = currentMatchup.getWinningSeed
    else
      nextRoundMatchup.nba_team2_id = currentMatchup.winning_nba_team_id
      nextRoundMatchup.team2_seed = currentMatchup.getWinningSeed
    end
  end

  # shows the winner page of the matchup w/ the specified id, including the specified error
  def showError(id, error)
    redirect_to '/nba_playoff_matchups/' + id.to_s + '/winner', notice: ("Error: " + error)
  end

  # DELETE /nba_playoff_matchups/1
  # DELETE /nba_playoff_matchups/1.json
  def destroy
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
    @nba_playoff_matchup.destroy

    respond_to do |format|
      format.html { redirect_to nba_playoff_matchups_url }
      format.json { head :no_content }
    end
  end

  # Returns the NBA teams eligible to be assigned to a playoff matchup.
  def getNbaTeams()
    return NbaTeam.order(:abbreviation).all
  end
end
