require 'test_helper'

class NbaPlayoffScoresControllerTest < ActionController::TestCase
  setup do
    @nba_playoff_score = nba_playoff_scores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nba_playoff_scores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nba_playoff_score" do
    assert_difference('NbaPlayoffScore.count') do
      post :create, nba_playoff_score: { name: @nba_playoff_score.name, points: @nba_playoff_score.points, round: @nba_playoff_score.round }
    end

    assert_redirected_to nba_playoff_score_path(assigns(:nba_playoff_score))
  end

  test "should show nba_playoff_score" do
    get :show, id: @nba_playoff_score
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nba_playoff_score
    assert_response :success
  end

  test "should update nba_playoff_score" do
    put :update, id: @nba_playoff_score, nba_playoff_score: { name: @nba_playoff_score.name, points: @nba_playoff_score.points, round: @nba_playoff_score.round }
    assert_redirected_to nba_playoff_score_path(assigns(:nba_playoff_score))
  end

  test "should destroy nba_playoff_score" do
    assert_difference('NbaPlayoffScore.count', -1) do
      delete :destroy, id: @nba_playoff_score
    end

    assert_redirected_to nba_playoff_scores_path
  end
end
