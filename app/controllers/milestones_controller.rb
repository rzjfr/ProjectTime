class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_milestone, only: [:edit, :update, :destroy]
  after_action :verify_authorized, except: [:create]

  def edit
    authorize @milestone
  end

  def update
    authorize @milestone
    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to :back, notice: 'Milestone was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def create
    @milestone = Milestone.new
    if current_user.owned_projects_ids.include?(params[:milestone][:project_id].to_i)
      @milestone = Milestone.create(milestone_params)
    else
      @milestone.errors.add(:milestone, "could be created only by the owner of the project.")
    end
    respond_to do |format|
      if @milestone.errors.messages.empty?
        format.html { redirect_to :back, notice: 'Milestone was successfully Created.'}
        format.js
      else
        format.html { redirect_to :back,
                      alert: @milestone.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join }
        format.js
      end
    end
  end

  def destroy
    authorize @milestone
    @project = Project.find(params[:project_id])
    Task.where(milestone_id: @milestone.id).update_all(milestone_id:
                                                       @project.first_milestone.id)
    @milestone.destroy
    respond_to do |format|
      format.html { redirect_to :back,
                    notice: "Milestone was successfully Removed. #{undo_link}" }
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

    def undo_link
      view_context.link_to("undo", revert_version_path(@milestone.versions.where(nil).last), method: :post)
    end
end
