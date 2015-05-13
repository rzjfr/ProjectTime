class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy,
                                     :statistics, :searches]
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :new, :create, :project_board]

  # GET /projects
  # GET /projects.json
  def index
    #@projects = Project.all
    @projects = current_user.projects
    @projects_in = Project.where('id in (?)',
                                 ProjectMember.where('user_id in (?) and owner is false',
                                                     current_user.id).pluck(:project_id))

  end

  def project_board
    if current_user.projects.empty?
      redirect_to projects_path
    else
      @user_tasks = Task.where(creator_id: current_user)
      if @user_tasks.empty?
        @project = current_user.projects.order(:updated_at).last
      else
        @project = current_user.projects.find(@user_tasks.order(:updated_at).last.project_id)
      end
      redirect_to @project
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project_members = @project.project_member
    authorize @project
    @milestones = @project.milestone
    @milestones_board = @milestones.where.not("end_date < (?) and id != (?)",
                                              Date.today,
                                              @project.first_milestone.id)
    @project_conversation = @project.project_conversation
  end

  def statistics
  end

  def searches
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project_members = @project.project_member
    @project_tasks = @project.task.order(:created_at).page params[:page]
    authorize @project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to root_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize @project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to :back, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    authorize @project
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
