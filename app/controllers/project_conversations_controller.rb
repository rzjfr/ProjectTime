class ProjectConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_conversations, only: [:destroy]

  def create
    @project_conversations = ProjectConversation.create(project_conversations_params)
    respond_to do |format|
      if @project_conversations.errors.messages.empty?
        format.html { redirect_to :back,
                      notice: 'Conversation was successfully Created.' }
        format.js
      else
        format.html { redirect_to :back,
                      alert: @project_conversations.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join }
        format.js
      end
    end
  end

  def destroy
  end

   private

     def project_conversations_params
       params.require(:project_conversation).permit(:project_id, :user_id, :content)
     end

    def set_project_conversations
      @project_conversations = ProjectConversation.find(params[:id])
    end

end
