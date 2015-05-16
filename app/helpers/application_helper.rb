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

  def mentioned_members_ids(project, message)
    titles = (project.project_member.pluck(:title) & message.scan(/@\w+/).map{|x| x[1..-1]})
    project.project_member.where("username in (?)", titles).pluck(:id)
  end

  def mentioned_tasks_ids(project, message)
    titles = (project.task.pluck(:title) & message.scan(/#\w+/).map{|x| x[1..-1]})
    project.task.where("title in (?)", titles).pluck(:id)
  end

  def all_relative_ids(conversation)
    project = Project.find(conversation.project_id)
    task_ids = mentioned_tasks_ids(project, conversation.content)
    #user_ids = mentioned_members_ids(project, conversation.content)
    ids = []
    Task.where("id in (?)", task_ids).pluck(:creator_id, :assignee_id).map {|x| ids.concat x}
    #ids.concat User.where("id in (?)", user_ids).pluck(:id)
    ids.uniq.reject {|x| x.nil?}
  end
end
