class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_milestone, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to edit_project_path(params[:milestone][:project_id]),
                      notice: 'Milestone was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @milestone = Milestone.create(milestone_params)
    respond_to do |format|
      if @milestone.errors.messages.empty?
        format.html { redirect_to edit_project_path(params[:milestone][:project_id]),
                      notice: 'Task was successfully Created.'}
        format.js
      else
        format.html { redirect_to edit_project_path(params[:milestone][:project_id]),
                      alert: @milestone.errors.full_messages.map { |msg| msg }.join}
        format.js
      end
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    Task.where(milestone_id: @milestone.id).update_all(milestone_id:
                                                       @project.first_milestone.id)
    @milestone.destroy
    respond_to do |format|
      format.html { redirect_to edit_project_path(params[:project_id]),
                    notice: 'Task was successfully Removed.'}
      format.js
    end
  end

   private

     def milestone_params
       params.require(:milestone).permit(:project_id, :title, :end_date)
     end

    def set_milestone
      @milestone = Milestone.find(params[:id])
    end
end
