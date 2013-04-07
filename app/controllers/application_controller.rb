class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  helper_method :getLoggedInUser

  def getLoggedInUser
    # TODO get user
    return User.last
  end

  # TODO highlight correct dropdown
end
