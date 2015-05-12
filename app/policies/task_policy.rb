class TaskPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def edit?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def send_next_state?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def postpone_task?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def postpone_task?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def send_current_milestone?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def update_row_order?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def update?
    user.admin? or (user.member_projects_ids.include? task.project_id)
  end

  def destroy?
    user.admin? or (user.member_projects_ids.include?(task.project_id) and (user.id == task.creator_id))
  end

end
