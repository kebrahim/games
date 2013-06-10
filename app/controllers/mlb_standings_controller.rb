class MlbStandingsController < ApplicationController
  # GET /mlb_standings
  # GET /mlb_standings.json
  def index
    @mlb_standings = MlbStanding.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mlb_standings }
    end
  end

  # GET /mlb_standings/1
  # GET /mlb_standings/1.json
  def show
    @mlb_standing = MlbStanding.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mlb_standing }
    end
  end

  # GET /mlb_standings/new
  # GET /mlb_standings/new.json
  def new
    @mlb_standing = MlbStanding.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mlb_standing }
    end
  end

  # GET /mlb_standings/1/edit
  def edit
    @mlb_standing = MlbStanding.find(params[:id])
  end

  # POST /mlb_standings
  # POST /mlb_standings.json
  def create
    @mlb_standing = MlbStanding.new(params[:mlb_standing])

    respond_to do |format|
      if @mlb_standing.save
        format.html { redirect_to @mlb_standing, notice: 'Mlb standing was successfully created.' }
        format.json { render json: @mlb_standing, status: :created, location: @mlb_standing }
      else
        format.html { render action: "new" }
        format.json { render json: @mlb_standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mlb_standings/1
  # PUT /mlb_standings/1.json
  def update
    @mlb_standing = MlbStanding.find(params[:id])

    respond_to do |format|
      if @mlb_standing.update_attributes(params[:mlb_standing])
        format.html { redirect_to @mlb_standing, notice: 'Mlb standing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mlb_standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlb_standings/1
  # DELETE /mlb_standings/1.json
  def destroy
    @mlb_standing = MlbStanding.find(params[:id])
    @mlb_standing.destroy

    respond_to do |format|
      format.html { redirect_to mlb_standings_url }
      format.json { head :no_content }
    end
  end
end
