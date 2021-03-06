class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def show?
    user.admin? or (project.members_ids.include? user.id)
  end

  def project_board?
    user.admin? or (user.id == project.user_id)
  end

  def statistics?
    user.admin? or (user.id == project.user_id)
  end

  def search?
    user.admin? or (project.members_ids.include? user.id)
  end

  def update?
    user.admin? or (user.id == project.user_id)
  end

  def destroy?
    user.admin? or (user.id == project.user_id)
  end

end
