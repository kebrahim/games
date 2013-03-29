module MlbWinBetsHelper
  include ActionView::Helpers::TagHelper
  
  TABLE_CLASS = 'table table-striped table-bordered table-condensed center'
  COL_NAMES = ['MLB Team', 'Line', 'Prediction', 'Amount']
    
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
    tablerow = "<tr>
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
  
end
