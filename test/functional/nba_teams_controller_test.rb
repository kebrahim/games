require 'test_helper'

class NbaTeamsControllerTest < ActionController::TestCase
  setup do
    @nba_team = nba_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nba_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nba_team" do
    assert_difference('NbaTeam.count') do
      post :create, nba_team: { abbreviation: @nba_team.abbreviation, city: @nba_team.city, division: @nba_team.division, league: @nba_team.league, name: @nba_team.name }
    end

    assert_redirected_to nba_team_path(assigns(:nba_team))
  end

  test "should show nba_team" do
    get :show, id: @nba_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nba_team
    assert_response :success
  end

  test "should update nba_team" do
    put :update, id: @nba_team, nba_team: { abbreviation: @nba_team.abbreviation, city: @nba_team.city, division: @nba_team.division, league: @nba_team.league, name: @nba_team.name }
    assert_redirected_to nba_team_path(assigns(:nba_team))
  end

  test "should destroy nba_team" do
    assert_difference('NbaTeam.count', -1) do
      delete :destroy, id: @nba_team
    end

    assert_redirected_to nba_teams_path
  end
end
