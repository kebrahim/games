require 'test_helper'

class MlbStandingsControllerTest < ActionController::TestCase
  setup do
    @mlb_standing = mlb_standings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mlb_standings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mlb_standing" do
    assert_difference('MlbStanding.count') do
      post :create, mlb_standing: { losses: @mlb_standing.losses, wins: @mlb_standing.wins, year: @mlb_standing.year }
    end

    assert_redirected_to mlb_standing_path(assigns(:mlb_standing))
  end

  test "should show mlb_standing" do
    get :show, id: @mlb_standing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mlb_standing
    assert_response :success
  end

  test "should update mlb_standing" do
    put :update, id: @mlb_standing, mlb_standing: { losses: @mlb_standing.losses, wins: @mlb_standing.wins, year: @mlb_standing.year }
    assert_redirected_to mlb_standing_path(assigns(:mlb_standing))
  end

  test "should destroy mlb_standing" do
    assert_difference('MlbStanding.count', -1) do
      delete :destroy, id: @mlb_standing
    end

    assert_redirected_to mlb_standings_path
  end
end
