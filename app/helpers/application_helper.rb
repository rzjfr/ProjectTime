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

  def statistics_active?
    in_project_statistics? ? "active" : ""
  end

  def search_active?
    in_project_search? ? "active" : ""
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

  def in_project_search?
    params[:controller] == "projects" && params[:action] == "search"
  end

  def in_project_statistics?
    params[:controller] == "projects" && params[:action] == "statistics"
  end

  def mentioned_members_ids(project, message)
    User.where("id in (?) and username in (?)",
               project.members_ids,
               message.scan(/@\w+/).map{|x| x[1..-1]}).pluck(:id)
  end

  def mentioned_tasks_ids(project, message)
    titles = (project.task.pluck(:title_digest) & message.scan(/#\w+/).map{|x| x[1..-1]})
    project.task.where("title_digest in (?)", titles).pluck(:id)
  end

  def all_relative_ids(conversation)
    project = Project.find(conversation.project_id)
    task_ids = mentioned_tasks_ids(project, conversation.content)
    user_ids = mentioned_members_ids(project, conversation.content)
    ids = []
    Task.where("id in (?)", task_ids).pluck(:creator_id, :assignee_id).map {|x| ids.concat x}
    ids.concat User.where("id in (?)", user_ids).pluck(:id)
    ids.uniq.reject {|x| x.nil? or x == conversation.user_id }
  end

  def message_reason(conversation, user)
    reason = []
    reason.append "owner" if (mentioned_tasks_ids(conversation.project,
                                                  conversation.content) &
                              user.task.pluck(:id)).present?
    reason.append "assigned" if (mentioned_tasks_ids(conversation.project,
                                                     conversation.content) &
                                 user.assigned.pluck(:id)).present?
    reason.append "mentioned" if (mentioned_members_ids(conversation.project,
                                  conversation.content).include? user.id)
    reason.append "concerned" if reason.empty?
    reason.join(" and ")
  end

  def mention_link(input)
    input.gsub(/#\w+/,'<span class="task-mention">\\0</span>').gsub(/@\w+/,'<span class="user-mention">\\0</span>')
  end

  def project_channel(key)
    Digest::SHA2.hexdigest(key.to_s + FAYE_CONFIG[:token])
  end

  def send_to_all(message, sender)
    message = {channel: "/messages/global",
               data: { text: message, type: "Public", from: sender },
               ext: {auth_token: FAYE_CONFIG[:token]} }
    uri = URI.parse(FAYE_CONFIG[:server])
    begin
      Net::HTTP.post_form(uri, message: message.to_json)
    rescue Errno::ECONNREFUSED
      puts "======================== Faye Server is down ===================="
    end
  end

  def push_block(channel, &block)
    message = {channel: "/messages/private/" + channel,
               data: capture(&block) ,
               ext: {auth_token: FAYE_CONFIG[:token]} }
    uri = URI.parse(FAYE_CONFIG[:server])
    begin
      Net::HTTP.post_form(uri, message: message.to_json)
    rescue Errno::ECONNREFUSED
      puts "======================== Faye Server is down ===================="
    end
  end

end
