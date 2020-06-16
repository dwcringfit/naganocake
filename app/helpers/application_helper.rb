module ApplicationHelper

  def flash_message_type(message_type)
    case message_type
    when "alert"
      "danger"
    when "notice"
      "info"
    else
      message_type
    end
  end
  
end
