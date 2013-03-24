require 'test_helper'

class MlbWinsControllerTest < ActionController::TestCase
  setup do
    @mlb_win = mlb_wins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mlb_wins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mlb_win" do
    assert_difference('MlbWin.count') do
      post :create, mlb_win: { actual: @mlb_win.actual, prediction: @mlb_win.prediction, year: @mlb_win.year }
    end

    assert_redirected_to mlb_win_path(assigns(:mlb_win))
  end

  test "should show mlb_win" do
    get :show, id: @mlb_win
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mlb_win
    assert_response :success
  end

  test "should update mlb_win" do
    put :update, id: @mlb_win, mlb_win: { actual: @mlb_win.actual, prediction: @mlb_win.prediction, year: @mlb_win.year }
    assert_redirected_to mlb_win_path(assigns(:mlb_win))
  end

  test "should destroy mlb_win" do
    assert_difference('MlbWin.count', -1) do
      delete :destroy, id: @mlb_win
    end

    assert_redirected_to mlb_wins_path
  end
end
