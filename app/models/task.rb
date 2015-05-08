class Task < ActiveRecord::Base
  include RankedModel
  ranks :row_order
  belongs_to :project
  validates :project_id, presence: true
  validates :title, length: { maximum: 20 }, presence: true
  validates :state, inclusion: { in: %w(Backlog Progress Done Archived),
                                 error: "%{value} is not a valid state" }
  validate :valid_assignee
  validates_uniqueness_of :title, scope: :project_id

  before_save {
    self.title = self.title.downcase
    if self.milestone_id.nil?
      self.milestone_id = Project.find(self.project_id).current_milestone.id
    end
  }

  def valid_assignee
    if assignee_id.present? && User.where(id: assignee_id).blank?
      errors.add(:user, 'there is not such a user.')
    end
  end

end
