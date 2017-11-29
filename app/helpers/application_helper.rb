module ApplicationHelper
  def flash_class(level)
    case level
      when "notice" then "alert alert-info flashBox"
      when "success" then "alert alert-success flashBox"
      when "error" then "alert alert-warning flashBox"
      when "alert" then "alert alert-danger flashBox"
    end
  end
end
