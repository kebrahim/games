module ApplicationHelper
  
  # Shows the specified notice as an alert and displays it as an error, if the notice string starts
  # with "Error"
  def showNoticeAsAlert(notice)
    noticeHTML = ""
    if !notice.nil? && !notice.empty?
      if notice.starts_with?("Error:")
        noticeHTML << "<div class='alert alert-error'>"
      else
        noticeHTML << "<div class='alert alert-success'>"
      end
      noticeHTML << "<button type='button' class='close' data-dismiss='alert'>&times;</button>" +
                    "<strong>" + notice + "</strong></div>"
    end
    return noticeHTML.html_safe
  end

end
