class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to edit_project_path(params[:task][:project_id]),
                      notice: 'Task was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @task = Task.create(task_params.merge(creator_id: current_user.id,
                                          state: 'Backlog'))
    respond_to do |format|
      if @task.errors.messages.empty?
        format.html { redirect_to edit_project_path(params[:task][:project_id]),
                      notice: 'Task was successfully Created.' }
        format.js
      else
        format.html { redirect_to edit_project_path(params[:task][:project_id]),
                      alert: @task.errors.full_messages.map { |msg| msg }.join }
        format.js
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to edit_project_path(params[:project_id]),
                    notice: 'Task was successfully Removed.'}
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
    @task.milestone_id = @project.current_milestone.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
        format.html { redirect_to @project, alert: 'There was an error.' }
      end
    end
  end

  def postpone_task
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @task.state = "Backlog"
    @task.milestone_id = @project.current_milestone.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
      else
      byebug
        format.html { redirect_to @project, alert: 'There was an error.' }
      end
    end
  end

  def update_row_order
    @task = Task.find(task_params[:task_id])
    @task.row_order_position = task_params[:row_order_position]
    @task.save

    render nothing: true
  end

   private

     def task_params
       params.require(:task).permit(:project_id, :title, :milestone_id,
                                    :description, :assignee_id, :estimate,
                                    :row_order_position, :task_id)
     end

    def set_task
      @task = Task.find(params[:id])
    end
end
