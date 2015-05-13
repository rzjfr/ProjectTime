class ProjectConversation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :content, length: { maximum: 320 }
end
