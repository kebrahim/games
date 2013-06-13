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
    standing = teamToStandingsMap[mlb_win.mlb_team_id]
      
    tablerow =
       "<tr>
          <td>" + mlb_win.mlb_team.abbreviation + "</td>
          <td>" + mlb_win.line.to_s + "</td>
          <td>" + standing.wins.to_s + "-" + standing.losses.to_s + "</td>
          <td>" + standing.projected_wins.to_s + "-" + standing.projected_losses.to_s + "</td>
          <td>" + standing.projected_result(mlb_win.line) + "</td>
        </tr>"
    return tablerow
  end

  def user_standings_link(user_id, rank, user_data)
    standings_link =
        "<button type='button' class='btn btn-link btn-link-black' data-toggle='collapse'
                  data-target='#user-collapse" + user_id.to_s + "'>
            <h5>" + rank.to_s + ". " + user_data["user"].fullName + " (" +
                    user_data["points"].to_s + ")</h5>
         </button>"
    return standings_link.html_safe
  end 

  def user_standings_row(bet, teamToStandingsMap)
    standing = teamToStandingsMap[bet.mlb_win.mlb_team_id]
    projected_result = standing.projected_result(bet.mlb_win.line)
    playerrow =
      "<tr>
         <td>" + bet.mlb_win.mlb_team.abbreviation + "</td>
         <td>" + bet.prediction + "</td>
         <td>" + bet.mlb_win.line.to_s + "</td>
         <td>" + standing.projected_wins.to_s + "-" + standing.projected_losses.to_s + " (" + 
                 projected_result + ")</td>
         <td class='"
    playerrow += (projected_result == bet.prediction) ? "green" : "red"
    playerrow += "'>" + bet.amount.to_s + "</td>
       </tr>"
    return playerrow.html_safe
  end
end
