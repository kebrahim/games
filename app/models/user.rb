class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :is_admin, :last_name, :password, :username
  has_many :mlb_win_bets

  # Returns the full name of the user
  def fullName
    return first_name + " " + last_name
  end
end
