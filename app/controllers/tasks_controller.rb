class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    @project = Project.find(params[:task][:project_id])
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @project = Project.find(params[:task][:project_id])
    @task = Task.create(task_params.merge(creator_id: current_user.id,
                                          state: 'Backlog'))
    respond_to do |format|
      if @task.errors.messages.empty?
        format.html { redirect_to @project, notice: 'Task was successfully Created.' }
        format.js
      else
        format.html { redirect_to @project, alert: @task.errors.full_messages.map { |msg| msg }.join }
        format.js
      end
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @project}
      format.js
    end
  end

  def send_next_state
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    case params[:state]
    when "Backlog"
        @task.state = "Progress"
    when "Progress"
        @task.state = "Done"
    when "Done"
        @task.state = "Archived"
    end
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
      byebug
        format.html { redirect_to @project, alert: 'There was an error.' }
      end
    end
  end

  def postpone_task
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @task.state = "Backlog"
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
      byebug
        format.html { redirect_to @project, alert: 'There was an error.' }
      end
    end
  end

   private

     def task_params
       params.require(:task).permit(:project_id, :title, :milestone_id,
                                    :description, :assignee_id, :estimate)
     end

    def set_task
      @task = Task.find(params[:id])
    end
end
