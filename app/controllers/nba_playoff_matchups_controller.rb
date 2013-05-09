class NbaPlayoffMatchupsController < ApplicationController
  # GET /nba_playoff_matchups
  # GET /nba_playoff_matchups.json
  def index
    @currentYear = Date.today.year

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

    # TODO winning_team, num_games should be updated in separate method, which updates score & adds
    # new matchups

    respond_to do |format|
      if @nba_playoff_matchup.update_attributes(params[:nba_playoff_matchup])
        format.html { redirect_to @nba_playoff_matchup, notice: 'Nba playoff matchup was successfully updated.' }
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
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
    @nba_teams = NbaTeam.where("id in (" + @nba_playoff_matchup.nba_team1_id.to_s + "," + 
      @nba_playoff_matchup.nba_team2_id.to_s + ")")
  end

  # POST /nba_playoff_matchups/1/winner
  def updatewinner
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params["nba_team_id"])
    if (params["winning_team_id"] != @nba_playoff_matchup.winning_nba_team_id)
      @nba_playoff_matchup.winning_nba_team_id = params["winning_team_id"].to_i      
    end
    if (params["total_games"] != @nba_playoff_matchup.total_games)
      @nba_playoff_matchup.total_games = params["total_games"].to_i      
    end

    if @nba_playoff_matchup.winning_nba_team_id == 0 || @nba_playoff_matchup.total_games == 0
      showError(@nba_playoff_matchup.id, "Error: Please select winner and total games")
    else
      if @nba_playoff_matchup.save
        # redirect to index.html w/ confirmation message
        redirect_to '/nba_playoff_matchups', notice: 'NBA Winner Saved!'
      else
        # redirect to set winner page w/ error message
        showError(@nba_playoff_matchup.id, "Error occurred while saving matchup")
      end
    end
     # TODO If corresponding matchup also has winner, create new matchup.
     # TODO Update standings.
  end

  def showError(id, error)
    redirect_to '/nba_playoff_matchups/' + id.to_s + '/winner', notice: error
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
