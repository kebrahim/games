require 'test_helper'

class MlbTeamsControllerTest < ActionController::TestCase
  setup do
    @mlb_team = mlb_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mlb_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mlb_team" do
    assert_difference('MlbTeam.count') do
      post :create, mlb_team: { abbreviation: @mlb_team.abbreviation, city: @mlb_team.city, division: @mlb_team.division, league: @mlb_team.league, name: @mlb_team.name }
    end

    assert_redirected_to mlb_team_path(assigns(:mlb_team))
  end

  test "should show mlb_team" do
    get :show, id: @mlb_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mlb_team
    assert_response :success
  end

  test "should update mlb_team" do
    put :update, id: @mlb_team, mlb_team: { abbreviation: @mlb_team.abbreviation, city: @mlb_team.city, division: @mlb_team.division, league: @mlb_team.league, name: @mlb_team.name }
    assert_redirected_to mlb_team_path(assigns(:mlb_team))
  end

  test "should destroy mlb_team" do
    assert_difference('MlbTeam.count', -1) do
      delete :destroy, id: @mlb_team
    end

    assert_redirected_to mlb_teams_path
  end
end
