class ProjectMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :project_id, uniqueness: {scope: :user_id}, presence: true
end
