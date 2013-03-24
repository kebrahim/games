require 'test_helper'

class MlbWinBetsControllerTest < ActionController::TestCase
  setup do
    @mlb_win_bet = mlb_win_bets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mlb_win_bets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mlb_win_bet" do
    assert_difference('MlbWinBet.count') do
      post :create, mlb_win_bet: { amount: @mlb_win_bet.amount, prediction: @mlb_win_bet.prediction }
    end

    assert_redirected_to mlb_win_bet_path(assigns(:mlb_win_bet))
  end

  test "should show mlb_win_bet" do
    get :show, id: @mlb_win_bet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mlb_win_bet
    assert_response :success
  end

  test "should update mlb_win_bet" do
    put :update, id: @mlb_win_bet, mlb_win_bet: { amount: @mlb_win_bet.amount, prediction: @mlb_win_bet.prediction }
    assert_redirected_to mlb_win_bet_path(assigns(:mlb_win_bet))
  end

  test "should destroy mlb_win_bet" do
    assert_difference('MlbWinBet.count', -1) do
      delete :destroy, id: @mlb_win_bet
    end

    assert_redirected_to mlb_win_bets_path
  end
end
