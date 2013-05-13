require 'test_helper'

class NbaPlayoffBetsControllerTest < ActionController::TestCase
  setup do
    @nba_playoff_bet = nba_playoff_bets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nba_playoff_bets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nba_playoff_bet" do
    assert_difference('NbaPlayoffBet.count') do
      post :create, nba_playoff_bet: { expected_nba_team_id: @nba_playoff_bet.expected_nba_team_id, expected_total_games: @nba_playoff_bet.expected_total_games, points: @nba_playoff_bet.points, year: @nba_playoff_bet.year }
    end

    assert_redirected_to nba_playoff_bet_path(assigns(:nba_playoff_bet))
  end

  test "should show nba_playoff_bet" do
    get :show, id: @nba_playoff_bet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nba_playoff_bet
    assert_response :success
  end

  test "should update nba_playoff_bet" do
    put :update, id: @nba_playoff_bet, nba_playoff_bet: { expected_nba_team_id: @nba_playoff_bet.expected_nba_team_id, expected_total_games: @nba_playoff_bet.expected_total_games, points: @nba_playoff_bet.points, year: @nba_playoff_bet.year }
    assert_redirected_to nba_playoff_bet_path(assigns(:nba_playoff_bet))
  end

  test "should destroy nba_playoff_bet" do
    assert_difference('NbaPlayoffBet.count', -1) do
      delete :destroy, id: @nba_playoff_bet
    end

    assert_redirected_to nba_playoff_bets_path
  end
end
