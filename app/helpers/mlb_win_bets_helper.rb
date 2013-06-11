module MlbWinBetsHelper
  include ActionView::Helpers::TagHelper
  
  TABLE_CLASS = 'table table-striped table-bordered table-condensed center'
  COL_NAMES = ['MLB Team', 'Line', 'Prediction', 'Bet Amount']
  STANDINGS_COL_NAMES = ['MLB Team', 'Line', 'Actual', 'On Pace', 'Result']
    
  def division_table(mlb_wins, title)
    tags = []
    tags << content_tag(:h4, title)
    content_tag(:table, class: TABLE_CLASS) do
      tags << content_tag(:thead,
          content_tag(:tr,
              COL_NAMES.collect { |name| content_tag(:th, name)}.join.html_safe))
      tags << content_tag(:tbody) do
        mlb_wins.each do |mlb_win|
          tags << old_selector_table_row(mlb_win).html_safe
        end
      end #content_tag :tbody
      tags.join.html_safe     
    end #content_tag :table
  end
     
  def selector_table_row(mlb_win)
    tags = []
    tags << content_tag(:tr) do
      tags << content_tag(:td, mlb_win.mlb_team.abbreviation)
      tags << content_tag(:td, mlb_win.line.to_s)
      # TODO select tag
    end
    tags.join.html_safe
  end
  
  def old_selector_table_row(mlb_win)
    tablerow = "<tr class='tdselect'>
            <td>" + mlb_win.mlb_team.abbreviation + "</td>
            <td>" + mlb_win.line.to_s + "</td>
            <td><select name='prediction" + mlb_win.id.to_s + "' class='input-small'>
                  <option value=0>---</option>
                  <option value=1>Over</option>
                  <option value=2>Under</option>
                </select>
            </td>
            <td>
              <select name='amount" + mlb_win.id.to_s + "' class='input-small'>
                                <option value=0>---</option>"
    
    # TODO 20 should be a const
    (1..20).each do |n|
      tablerow << "<option value=" + n.to_s + ">" + n.to_s + "</option>"                   
    end
                                
    tablerow << 
              "</select>
            </td>
          </tr>"
    return tablerow
  end

  # TODO combine these two methods
  def existing_bet_table_row(mlb_win_bet, row_number)
    tablerow = "<tr class='tdselect'>
            <td>" + row_number.to_s + "</td>
            <td>" + mlb_win_bet.mlb_win.mlb_team.abbreviation + "</td>
            <td>" + mlb_win_bet.mlb_win.line.to_s + "</td>
            <td><select name='prediction" + mlb_win_bet.mlb_win.id.to_s + "' class='input-small'>
                  <option value=1"
    if mlb_win_bet.prediction == "Over"
      tablerow << " selected"
    end
    tablerow <<                  ">Over</option>
                  <option value=2"
    if mlb_win_bet.prediction == "Under"
      tablerow << " selected"
    end
    tablerow <<                  ">Under</option>
                </select>
            </td>
            <td>
              <select name='amount" + mlb_win_bet.mlb_win.id.to_s + "' class='input-small'>
                                <option value=0>---</option>"
    
    # TODO 20 should be a const
    (1..20).each do |n|
      tablerow << "<option value=" + n.to_s
      if mlb_win_bet.amount == n
        tablerow << " selected"
      end
      tablerow << ">" + n.to_s + "</option>"                   
    end
 
    tablerow << 
              "</select>
            </td>
            <td>" + (link_to 'X', mlb_win_bet, method: :delete, 
                    data: { confirm: 'Are you sure you want to remove this bet?' }).html_safe + 
           "</td>
          </tr>"
    return tablerow.html_safe
  end

  def division_standings_table(league, division, year, teamToStandingsMap)
    tags = []
    mlb_wins = 
        MlbWin.joins(:mlb_team)
              .where(year: year)
              .where("mlb_teams.league = '" + league +
                     "' and mlb_teams.division = '" + division + "'")
              .order("line DESC")
    tags << content_tag(:h5, league + " " + division)
    content_tag(:table, class: TABLE_CLASS) do
      tags << content_tag(:thead,
          content_tag(:tr,
              STANDINGS_COL_NAMES.collect { |name| content_tag(:th, name)}.join.html_safe))
      tags << content_tag(:tbody) do
        mlb_wins.each do |mlb_win|
          tags << team_standings_row(mlb_win, teamToStandingsMap).html_safe
        end
      end #content_tag :tbody
      tags.join.html_safe     
    end #content_tag :table
  end
  
  def team_standings_row(mlb_win, teamToStandingsMap)
    winLoss = teamToStandingsMap.nil? ? [0,0] : teamToStandingsMap[mlb_win.mlb_team_id]
    wins = winLoss[0]
    losses = winLoss[1]
    games = wins + losses
    if games > 0
      pred_wins = ((wins / games.to_f) * 162).round
      pred_losses = 162 - pred_wins
    else
      pred_wins = 0
      pred_losses = 0
    end
    if pred_wins < mlb_win.line
      result = 'Under'
    elsif pred_wins > mlb_win.line
      result = 'Over'      
    else
      result = 'Push'
    end
      
    tablerow =
       "<tr>
          <td>" + mlb_win.mlb_team.abbreviation + "</td>
          <td>" + mlb_win.line.to_s + "</td>
          <td>" + wins.to_s + "-" + losses.to_s + "</td>
          <td>" + pred_wins.to_s + "-" + pred_losses.to_s + "</td>
          <td>" + result + "</td>
        </tr>"
    return tablerow
  end

  def user_standings_link(user)
    standings_link =
        "<button type='button' class='btn btn-link btn-link-black' data-toggle='collapse'
                  data-target='#user-collapse" + user.id.to_s + "'>
            <h5>" + user.fullName + "</h5>
         </button>"
    return standings_link.html_safe
  end 

  def user_standings_row(bet, teamToStandingsMap)
    winLoss = teamToStandingsMap[bet.mlb_win.mlb_team_id]
    wins = winLoss[0]
    losses = winLoss[1]
    games = wins + losses
    if games > 0
      pred_wins = ((wins / games.to_f) * 162).round
      pred_losses = 162 - pred_wins
    else
      pred_wins = 0
      pred_losses = 0
    end
    if pred_wins < bet.mlb_win.line
      result = 'Under'
    elsif pred_wins > bet.mlb_win.line
      result = 'Over'      
    else
      result = 'Push'
    end

    playerrow =
      "<tr>
         <td>" + bet.mlb_win.mlb_team.abbreviation + "</td>
         <td>" + bet.prediction + "</td>
         <td>" + bet.mlb_win.line.to_s + "</td>
         <td>" + pred_wins.to_s + "-" + pred_losses.to_s + " (" + result + ")</td>
         <td class='"
    playerrow += (result == bet.prediction) ? "green" : "red"
    playerrow += "'>" + bet.amount.to_s + "</td>
       </tr>"
    return playerrow.html_safe
  end
end
