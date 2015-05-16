class ProjectConversation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :message
  validates :content, length: { maximum: 320 }
  default_scope ->{ order('created_at DESC') }
  paginates_per 5

  after_save {
    #Message.create
    ApplicationController.helpers.all_relative_ids(self).each do |id|
      Message.create({project_conversation_id: self.id,
                      user_id: self.user_id, reciver_id: id})
    end
  }

end
