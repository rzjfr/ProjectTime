class ProjectMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find_by_username(params[:project_member][:user_id])
    @project = Project.find(params[:project_member][:project_id])
    @project.add_project_member(@user, @project)
    respond_to do |format|
    if @project.errors.any?
      format.html { redirect_to :back, alert: "no user with that username!" }
      format.js
    else
      format.html { redirect_to :back, notice: "User Successfuly added." }
      format.js
    end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @project.remove_project_member(@user, @project)
    respond_to do |format|
      format.html { redirect_to :back, notice: "User Removed!" }
      format.js
    end
  end

end
