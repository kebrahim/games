class MlbWin < ActiveRecord::Base
  attr_accessible :actual, :line, :year
  belongs_to :mlb_team
  has_many :mlb_win_bets
  
  def selector_table_row
    return "<tr>
            <td>" + mlb_team.abbreviation + "</td>
            <td>" + line.to_s + "</td>
            <td></td>
            <td></td>
            </tr>"
  end
end
