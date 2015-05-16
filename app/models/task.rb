class Task < ActiveRecord::Base
  include RankedModel
  ranks :row_order, :with_same => :task_class

  has_paper_trail :ignore => [:row_order]

  belongs_to :project
  validates :project_id, presence: true
  validates :title, length: { maximum: 20 }, presence: true
  validates :state, inclusion: { in: %w(Backlog Progress Done Archived),
                                 error: "%{value} is not a valid state" }
  validate :valid_assignee
  validates_uniqueness_of :title, scope: :project_id
  scope :done, -> {where(state: "Done" )}
  scope :progress, -> {where(state: "Progress" )}
  scope :backlog, -> {where(state: "Backlog" )}

  before_save {
    self.title = self.title.downcase
    self.task_class = self.project_id.to_s + self.state + self.milestone_id.to_s
    if self.milestone_id.nil?
      self.milestone_id = Project.find(self.project_id).current_milestone.id
    end
  }

  def valid_assignee
    if assignee_id.present? && User.where(id: assignee_id).blank?
      errors.add(:user, 'there is not such a user.')
    end
  end

  def last_change_by
    User.find(self.versions.last.whodunnit.to_i) if !self.versions.last.nil?
  end

  def last_changes
    self.versions.last.changeset if !self.versions.last.nil?
  end

end
