module NbaPlayoffMatchupsHelper
  include ActionView::Helpers::TagHelper
  
  TABLE_CLASS = 'table table-striped table-bordered table-condensed center'
  COL_NAMES = ['Position', 'Team', 'Team', 'Winner', 'Total games', '', '', '', '']
  
  # Returns the admin table of NBA playoff matchups for the specified year and round.
  def admin_round_table(year, round)
    # TODO move to controller
    nba_playoff_matchups =
        NbaPlayoffMatchup.includes(:nba_team1)
                         .includes(:nba_team2)
                         .includes(:winning_nba_team)
                         .where(year: year, round: round)
                         .order(:position)
    if (nba_playoff_matchups.empty?)
      return ""
    end

    tags = []
    tags << content_tag(:h4, "Round " + round.to_s)
    content_tag(:table, class: TABLE_CLASS) do
      tags << content_tag(:thead,
          content_tag(:tr,
              COL_NAMES.collect { |name| content_tag(:th, name)}.join.html_safe))
      tags << content_tag(:tbody) do
        nba_playoff_matchups.each do |nba_playoff_matchup|
          tags << nba_playoff_matchup_row(nba_playoff_matchup).html_safe
        end
      end #content_tag :tbody
      tags.join.html_safe     
    end #content_tag :table
  end

  # Returns a row in the NBA Playoff matchup table, using the specified matchup.
  def nba_playoff_matchup_row(nba_playoff_matchup)
    tablerow =
       "<tr>
          <td>" + nba_playoff_matchup.position.to_s + "</td>
          <td>" + (nba_playoff_matchup.nba_team1 != nil ? nba_playoff_matchup.team1_seed.to_s + " - " + nba_playoff_matchup.nba_team1.abbreviation : "--") + "</td>
          <td>" + (nba_playoff_matchup.nba_team2 != nil ? nba_playoff_matchup.team2_seed.to_s + " - " + nba_playoff_matchup.nba_team2.abbreviation : "--") + "</td>
          <td>" + (nba_playoff_matchup.winning_nba_team != nil ? nba_playoff_matchup.winning_nba_team.abbreviation : "--") + "</td>
          <td>" + (nba_playoff_matchup.winning_nba_team != nil ? nba_playoff_matchup.total_games.to_s : "--") + "</td>
          <td>" + link_to('Show', nba_playoff_matchup) + "</td>
          <td>" + link_to('Set Winner', 'nba_playoff_matchups/' + nba_playoff_matchup.id.to_s + '/winner') + "</td>
          <td>" + link_to('Edit', edit_nba_playoff_matchup_path(nba_playoff_matchup)) + "</td>
          <td>" + link_to('Destroy', nba_playoff_matchup, method: :delete, data: { confirm: 'Are you sure?' }) + "</td>
        </tr>"
    return tablerow
  end
end
