module ApplicationHelper
  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end

  def teamwork_url
    Teamwork::TEAMWORK_URL
  end

  def flash_class name
    # Translate rails conventions to bootstrap conventions
    case name.to_sym
    when :notice
      :success
    when :alert
      :danger
    else
      name
    end
  end
end
