module ApplicationHelper
  def active?(path)
    current_page?(path) ? "active" : ""
  end

  def home_active?
    in_project_board? ? "active" : ""
  end

  def edit_active?
    in_project_edit? ? "active" : ""
  end

  def related_page?(resource)
    request.path.split('/')[1] == resource || request.path == "/"
  end

  def in_project_board?
    params[:controller] == "projects" && params[:action] == "show"
  end

  def in_project_edit?
    params[:controller] == "projects" && params[:action] == "edit"
  end
end
