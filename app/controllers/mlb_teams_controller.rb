class MlbTeamsController < ApplicationController
  # GET /mlb_teams
  # GET /mlb_teams.json
  def index
    @mlb_teams = MlbTeam.order(:league, :division, :city).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_teams }
    end
  end

  # GET /mlb_teams/1
  # GET /mlb_teams/1.json
  def show
    @mlb_team = MlbTeam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mlb_team }
    end
  end

  # GET /mlb_teams/new
  # GET /mlb_teams/new.json
  def new
    @mlb_team = MlbTeam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mlb_team }
    end
  end

  # GET /mlb_teams/1/edit
  def edit
    @mlb_team = MlbTeam.find(params[:id])
  end

  # POST /mlb_teams
  # POST /mlb_teams.json
  def create
    @mlb_team = MlbTeam.new(params[:mlb_team])

    respond_to do |format|
      if @mlb_team.save
        format.html { redirect_to @mlb_team, notice: 'Mlb team was successfully created.' }
        format.json { render json: @mlb_team, status: :created, location: @mlb_team }
      else
        format.html { render action: "new" }
        format.json { render json: @mlb_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mlb_teams/1
  # PUT /mlb_teams/1.json
  def update
    @mlb_team = MlbTeam.find(params[:id])

    respond_to do |format|
      if @mlb_team.update_attributes(params[:mlb_team])
        format.html { redirect_to @mlb_team, notice: 'Mlb team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mlb_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlb_teams/1
  # DELETE /mlb_teams/1.json
  def destroy
    @mlb_team = MlbTeam.find(params[:id])
    @mlb_team.destroy

    respond_to do |format|
      format.html { redirect_to mlb_teams_url }
      format.json { head :no_content }
    end
  end
end
