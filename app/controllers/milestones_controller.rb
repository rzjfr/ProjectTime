class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_milestone, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    @project = Project.find(params[:milestone][:project_id])
    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to @project, notice: 'Milestone was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @project = Project.find(params[:milestone][:project_id])
    @milestone = Milestone.create(milestone_params)
    respond_to do |format|
      if @milestone.errors.messages.empty?
        format.html { redirect_to @project, notice: 'Task was successfully Created.'}
        format.js
      else
        format.html { redirect_to @project, alert: @milestone.errors.full_messages.map { |msg| msg }.join}
        format.js
      end
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @milestone.destroy
    respond_to do |format|
      format.html { redirect_to @project}
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
