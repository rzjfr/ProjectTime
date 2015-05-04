class Task < ActiveRecord::Base
  belongs_to :project
  validates :project_id, presence: true
  validates :title, length: { maximum: 20 }, presence: true
  validates :state, inclusion: { in: %w(Backlog Progress Done Archived),
                                 error: "%{value} is not a valid state" }
  validate :valid_assignee
  validate :uniqueness_in_scope

  def uniqueness_in_scope
    if Project.find(self.project_id).task.where(title: self.title.downcase).present?
      errors.add(:name, ': you have already created a task with that name.')
    end
  end

  before_save { self.title = self.title.downcase }

  def valid_assignee
    if assignee_id.present? && User.where(id: assignee_id).blank?
      errors.add(:user, 'there is not such a user.')
    end
  end

end
