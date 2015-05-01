class ProjectMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:project_member][:user_id])
    @project = Project.find(params[:project_member][:project_id])
    @project.add_project_member(@user, @project)
    respond_to do |format|
      format.html { redirect_to @project }
      format.js
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @project.remove_project_member(@user, @project)
    respond_to do |format|
      format.html { redirect_to @project }
      format.js
    end
  end

end
