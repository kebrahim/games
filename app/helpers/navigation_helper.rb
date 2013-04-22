# Navigation bar helper
module NavigationHelper
  # construct mapping of sport to game
  MY_GAMES_BUTTON = 1
  MLB_OVER_UNDERS_BUTTON = 2
  NBA_PLAYOFFS_BUTTON = 3
  EDIT_PROFILE_BUTTON = 4
  ADMIN_MLB_TEAMS_BUTTON = 5
  ADMIN_NBA_TEAMS_BUTTON = 6

  # Returns the navigation bar HTML w/ the specified button selected
  # TODO pull list of games from db
  def navigationBar(button)
    navbar = "<div class='navbar'><div class='navbar-inner'>"
    if current_user
      navbar << "
        <div class='brand'>Rotiss Games</div>
          <ul class='nav'>
            <li class='divider-vertical'></li>
         	<li"
      if (button == MY_GAMES_BUTTON)
        navbar << " class='active'"
      end
      navbar << "><a href='myGames'>My Games</a></li>
            <li class='divider-vertical'></li>
       	    <li class='dropdown"
      if (isMlbButton(button))
        navbar << " active"
      end
      navbar <<               "'>
              <a href='#' class='dropdown-toggle profiledropdown' data-toggle='dropdown'>
                MLB&nbsp<b class='caret'></b>
              </a>
              <ul class='dropdown-menu'>
                <li"
      if (button == MLB_OVER_UNDERS_BUTTON)
        navbar << " class='active'"
      end
      navbar <<    ">
                  <a href='mlbOverUnders'>Over/Unders</a>
                </li>
              </ul>
            </li>

            <li class='dropdown"
      if (isNbaButton(button))
        navbar << " active"
      end
      navbar <<               "'>
              <a href='#' class='dropdown-toggle profiledropdown' data-toggle='dropdown'>
                NBA&nbsp<b class='caret'></b>
              </a>
              <ul class='dropdown-menu'>
                <li"
      if (button == NBA_PLAYOFFS_BUTTON)
        navbar << " class='active'"
      end
      navbar <<    ">
                  <a href='nbaPlayoffs'>Playoffs</a>
                </li>
              </ul>
            </li>

            <li class='dropdown'>
              <a href='#' class='dropdown-toggle profiledropdown' data-toggle='dropdown'>
                NFL&nbsp<b class='caret'></b>
              </a>
              <ul class='dropdown-menu'>
                <li>
                  <a href='#'>Coming soon...</a>
                </li>
              </ul>
            </li>"
      if (current_user.is_admin == true)
        navbar << 
           "<li class='dropdown"
        if (isAdminButton(button))
          navbar << " active"
        end
        navbar <<             "'>
              <a href='#' class='dropdown-toggle profiledropdown' data-toggle='dropdown'>
                Admin&nbsp<b class='caret'></b>
              </a>
              <ul class='dropdown-menu'>
                <li"
        if (button == ADMIN_MLB_TEAMS_BUTTON)
          navbar << " class='active'"
        end
        navbar <<    ">
                  <a href='mlb_teams'>MLB Teams</a>
                </li>
                <li"
        if (button == ADMIN_NBA_TEAMS_BUTTON)
          navbar << " class='active'"
        end
        navbar <<    ">
                  <a href='nba_teams'>NBA Teams</a>
                </li>
              </ul>
            </li>"
      end
      navbar << "</ul>
          <ul class='nav pull-right'>
            <li class='divider-vertical'></li>
  	        <li class='dropdown"
      if (button == EDIT_PROFILE_BUTTON)
        navbar << " active"
      end
  	  navbar <<                "'>
  	          <a href='#' class='dropdown-toggle profiledropdown' data-toggle='dropdown'>
  	            Hi "
      navbar << current_user.first_name
  	  navbar << "!&nbsp<b class='caret'></b></a>
  	          <ul class='dropdown-menu'>
  	          	<li"
      if (button == EDIT_PROFILE_BUTTON)
        navbar << " class='active'"
      end
  	  navbar <<    ">
                  <a href='editProfile'><i class='icon-edit'></i>&nbsp&nbspEdit profile</a>
                </li>
  	            <li class='divider'></li>
  	            <li><a href='logout'><i class='icon-eject'></i>&nbsp&nbspSign out</a></li>
  	          </ul>
  	        </li>
  	      </ul>"
    else
      navbar << "<div class='brand brandctr'>Rotiss Games</div>"
    end
  	
  	navbar << "</div></div>"
  	return navbar.html_safe
  end

  def isMlbButton(button)
    return (button == MLB_OVER_UNDERS_BUTTON)
  end

  def isNbaButton(button)
    return (button == NBA_PLAYOFFS_BUTTON)
  end

  def isAdminButton(button)
    return (button == ADMIN_MLB_TEAMS_BUTTON) || (button == ADMIN_NBA_TEAMS_BUTTON)
  end
end