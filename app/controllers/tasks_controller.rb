class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]
  after_action :verify_authorized, except: [:create]

  def edit
    authorize @task
    @project = Project.find(@task.project_id)
  end

  def update
    authorize @task
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to :back,
                      notice: "Task was successfully updated. #{undo_link}" }
        format.js# {render partial: "edit_task"}
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def create
    @task = Task.create(task_params.merge(creator_id: current_user.id,
                                          state: 'Backlog'))
    respond_to do |format|
      if @task.errors.messages.empty?
        format.html { redirect_to :back,
                      notice: 'Task was successfully Created.' }
        format.js
      else
        format.html { redirect_to :back,
                      alert: @task.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join }
        format.js
      end
    end
  end

  def destroy
    authorize @task
    @task.destroy
    respond_to do |format|
      format.html { redirect_to :back,
                    notice: "Task was successfully Removed. #{undo_link}" }
      format.js
    end
  end

  def send_next_state
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    authorize @task
    case @task.state
    when "Backlog"
        @next_state = "Progress"
    when "Progress"
        @next_state = "Done"
    when "Done"
        @next_state = "Archived"
    end
    @task.update_attribute :row_order_position, :last
    if (@task.assignee_id.nil? || @task.estimate.nil?)
      @task.errors.add(:task, "Please fill in estimate and assigned user.")
    else
      @task.state = @next_state
      @task.milestone_id = @project.current_milestone.id
      @task.save
    end
    respond_to do |format|
      if !@task.errors.any?
        format.html { redirect_to @project}
        format.js
      else
        format.html { redirect_to @project, alert: 'There was an error.' }
        format.js
      end
    end
  end

  def postpone_task
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    authorize @task
    @task.state = "Backlog"
    @task.milestone_id = @project.first_milestone.id
    @task.update_attribute :row_order_position, :last
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project}
        format.js
      else
        format.html { redirect_to @project, alert: 'There was an error.' }
        format.js
      end
    end
  end

  def send_current_milestone
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    authorize @task
    @task.milestone_id = @project.current_milestone.id
    @task.update_attribute :row_order_position, :last
    respond_to do |format|
      if @task.save
        format.html { redirect_to @project}
        format.js
      else
        format.html { redirect_to @project, alert: 'There was an error.' }
        format.js
      end
    end
  end

  def update_row_order
    @task = Task.find(task_params[:task_id])
    authorize @task
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

    def undo_link
      view_context.link_to("undo", revert_version_path(@task.versions.where(nil).last), method: :post)
    end

end
