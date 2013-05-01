class NbaPlayoffMatchupsController < ApplicationController
  # GET /nba_playoff_matchups
  # GET /nba_playoff_matchups.json
  def index
    @nba_playoff_matchups = NbaPlayoffMatchup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nba_playoff_matchups }
    end
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nba_playoff_matchup }
    end
  end

  # GET /nba_playoff_matchups/1/edit
  def edit
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])
  end

  # POST /nba_playoff_matchups
  # POST /nba_playoff_matchups.json
  def create
    @nba_playoff_matchup = NbaPlayoffMatchup.new(params[:nba_playoff_matchup])

    respond_to do |format|
      if @nba_playoff_matchup.save
        format.html { redirect_to @nba_playoff_matchup, notice: 'Nba playoff matchup was successfully created.' }
        format.json { render json: @nba_playoff_matchup, status: :created, location: @nba_playoff_matchup }
      else
        format.html { render action: "new" }
        format.json { render json: @nba_playoff_matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nba_playoff_matchups/1
  # PUT /nba_playoff_matchups/1.json
  def update
    @nba_playoff_matchup = NbaPlayoffMatchup.find(params[:id])

    respond_to do |format|
      if @nba_playoff_matchup.update_attributes(params[:nba_playoff_matchup])
        format.html { redirect_to @nba_playoff_matchup, notice: 'Nba playoff matchup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nba_playoff_matchup.errors, status: :unprocessable_entity }
      end
    end
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
end
