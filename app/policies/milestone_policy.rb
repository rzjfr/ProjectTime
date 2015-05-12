class MilestonePolicy < ApplicationPolicy
  attr_reader :user, :milestone

  def initialize(user, milestone)
    @user = user
    @milestone = milestone
  end

  def edit?
    user.admin? or (user.owned_projects_ids.include? milestone.project_id)
  end

  def update?
    user.admin? or (user.owned_projects_ids.include? milestone.project_id)
  end

  def destroy?
    user.admin? or (user.owned_projects_ids.include? milestone.project_id)
  end

end
