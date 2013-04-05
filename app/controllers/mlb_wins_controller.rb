class MlbWinsController < ApplicationController
  # GET /mlb_wins
  # GET /mlb_wins.json
  def index
    # TODO filter by year
    @mlb_wins = MlbWin.includes(:mlb_team).order("year DESC, mlb_teams.abbreviation").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_wins }
    end
  end

  # GET /mlb_wins/1
  # GET /mlb_wins/1.json
  def show
    @mlb_win = MlbWin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mlb_win }
    end
  end

  # GET /mlb_wins/new
  # GET /mlb_wins/new.json
  def new
    @mlb_win = MlbWin.new
    
    currentYear = Date.today.year
    yearFilter = MlbWin.where(year: currentYear).select(:mlb_team_id).to_sql
    @mlb_teams = MlbTeam.where("id not in (#{yearFilter})").order(:abbreviation)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mlb_win }
    end
  end

  # GET /mlb_wins/1/edit
  def edit
    @mlb_win = MlbWin.find(params[:id])
    @mlb_teams = MlbTeam.where(id: @mlb_win.mlb_team_id)
  end

  # POST /mlb_wins
  # POST /mlb_wins.json
  def create
    @mlb_win = MlbWin.new(params[:mlb_win])
    @mlb_win.mlb_team_id = params[:mlb_team_id]
      
    respond_to do |format|
      if @mlb_win.save
        format.html { redirect_to @mlb_win, notice: 'Mlb win was successfully created.' }
        format.json { render json: @mlb_win, status: :created, location: @mlb_win }
      else
        format.html { render action: "new" }
        format.json { render json: @mlb_win.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mlb_wins/1
  # PUT /mlb_wins/1.json
  def update
    @mlb_win = MlbWin.find(params[:id])

    respond_to do |format|
      if @mlb_win.update_attributes(params[:mlb_win])
        format.html { redirect_to @mlb_win, notice: 'Mlb win was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mlb_win.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlb_wins/1
  # DELETE /mlb_wins/1.json
  def destroy
    @mlb_win = MlbWin.find(params[:id])
    @mlb_win.destroy

    respond_to do |format|
      format.html { redirect_to mlb_wins_url }
      format.json { head :no_content }
    end
  end
end
