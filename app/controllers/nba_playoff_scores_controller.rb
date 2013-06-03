class NbaPlayoffScoresController < ApplicationController
  # GET /nba_playoff_scores
  # GET /nba_playoff_scores.json
  def index
    @nba_playoff_scores = NbaPlayoffScore.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nba_playoff_scores }
    end
  end

  # GET /nba_playoff_scores/1
  # GET /nba_playoff_scores/1.json
  def show
    @nba_playoff_score = NbaPlayoffScore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nba_playoff_score }
    end
  end

  # GET /nba_playoff_scores/new
  # GET /nba_playoff_scores/new.json
  def new
    @nba_playoff_score = NbaPlayoffScore.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nba_playoff_score }
    end
  end

  # GET /nba_playoff_scores/1/edit
  def edit
    # TODO confirm logged-in user is admin
    @nba_playoff_score = NbaPlayoffScore.find(params[:id])
  end

  # POST /nba_playoff_scores
  # POST /nba_playoff_scores.json
  def create
    @nba_playoff_score = NbaPlayoffScore.new(params[:nba_playoff_score])

    respond_to do |format|
      if @nba_playoff_score.save
        format.html { redirect_to @nba_playoff_score, notice: 'Nba playoff score was successfully created.' }
        format.json { render json: @nba_playoff_score, status: :created, location: @nba_playoff_score }
      else
        format.html { render action: "new" }
        format.json { render json: @nba_playoff_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nba_playoff_scores/1
  # PUT /nba_playoff_scores/1.json
  def update
    # TODO confirm logged-in user is admin
    @nba_playoff_score = NbaPlayoffScore.find(params[:id])

    respond_to do |format|
      if @nba_playoff_score.update_attributes(params[:nba_playoff_score])
        format.html { redirect_to '/nba_playoff_matchups',
                      notice: 'NBA playoff scoring formula updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nba_playoff_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nba_playoff_scores/1
  # DELETE /nba_playoff_scores/1.json
  def destroy
    # TODO confirm logged-in user is admin
    @nba_playoff_score = NbaPlayoffScore.find(params[:id])
    @nba_playoff_score.destroy

    respond_to do |format|
      format.html { redirect_to '/nba_playoff_matchups',
                    notice: 'NBA playoff scoring formula destroyed.' }
      format.json { head :no_content }
    end
  end
end
