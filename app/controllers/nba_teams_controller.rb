class NbaTeamsController < ApplicationController
  # GET /nba_teams
  # GET /nba_teams.json
  def index
    @nba_teams = NbaTeam.order(:abbreviation).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nba_teams }
    end
  end

  # GET /nba_teams/1
  # GET /nba_teams/1.json
  def show
    @nba_team = NbaTeam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nba_team }
    end
  end

  # GET /nba_teams/new
  # GET /nba_teams/new.json
  def new
    @nba_team = NbaTeam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nba_team }
    end
  end

  # GET /nba_teams/1/edit
  def edit
    @nba_team = NbaTeam.find(params[:id])
  end

  # POST /nba_teams
  # POST /nba_teams.json
  def create
    @nba_team = NbaTeam.new(params[:nba_team])

    respond_to do |format|
      if @nba_team.save
        format.html { redirect_to @nba_team, notice: 'Nba team was successfully created.' }
        format.json { render json: @nba_team, status: :created, location: @nba_team }
      else
        format.html { render action: "new" }
        format.json { render json: @nba_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nba_teams/1
  # PUT /nba_teams/1.json
  def update
    @nba_team = NbaTeam.find(params[:id])

    respond_to do |format|
      if @nba_team.update_attributes(params[:nba_team])
        format.html { redirect_to @nba_team, notice: 'Nba team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nba_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nba_teams/1
  # DELETE /nba_teams/1.json
  def destroy
    @nba_team = NbaTeam.find(params[:id])
    @nba_team.destroy

    respond_to do |format|
      format.html { redirect_to nba_teams_url }
      format.json { head :no_content }
    end
  end
end
