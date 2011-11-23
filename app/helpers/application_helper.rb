module ApplicationHelper
  def logo
    image_tag("logo.png", :alt => "sample app", :class => "round")
  end
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
