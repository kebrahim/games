require 'test_helper'

class NbaPlayoffMatchupsControllerTest < ActionController::TestCase
  setup do
    @nba_playoff_matchup = nba_playoff_matchups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nba_playoff_matchups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nba_playoff_matchup" do
    assert_difference('NbaPlayoffMatchup.count') do
      post :create, nba_playoff_matchup: { position: @nba_playoff_matchup.position, round: @nba_playoff_matchup.round, team1_seed: @nba_playoff_matchup.team1_seed, team2_seed: @nba_playoff_matchup.team2_seed, total_games: @nba_playoff_matchup.total_games, year: @nba_playoff_matchup.year }
    end

    assert_redirected_to nba_playoff_matchup_path(assigns(:nba_playoff_matchup))
  end

  test "should show nba_playoff_matchup" do
    get :show, id: @nba_playoff_matchup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nba_playoff_matchup
    assert_response :success
  end

  test "should update nba_playoff_matchup" do
    put :update, id: @nba_playoff_matchup, nba_playoff_matchup: { position: @nba_playoff_matchup.position, round: @nba_playoff_matchup.round, team1_seed: @nba_playoff_matchup.team1_seed, team2_seed: @nba_playoff_matchup.team2_seed, total_games: @nba_playoff_matchup.total_games, year: @nba_playoff_matchup.year }
    assert_redirected_to nba_playoff_matchup_path(assigns(:nba_playoff_matchup))
  end

  test "should destroy nba_playoff_matchup" do
    assert_difference('NbaPlayoffMatchup.count', -1) do
      delete :destroy, id: @nba_playoff_matchup
    end

    assert_redirected_to nba_playoff_matchups_path
  end
end
