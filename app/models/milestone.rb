class Milestone < ActiveRecord::Base
  has_paper_trail :on => [:destroy, :create]

  belongs_to :project
  has_many :task#, dependent: :destroy
  default_scope { order('end_date ASC') }
  validates :title, length: { maximum: 200 }, presence: true
  validates :end_date, uniqueness: {scope: :project_id}, presence: true
  validate :valid_end_date

  def valid_end_date
    if end_date.present? && (end_date < Date.today)
      errors.add(:end_date, 'must be a passed date.')
    end
  end

  def passed?
    self.end_date < Date.today
  end

  def full_title
    if self.id == Project.find(self.project_id).first_milestone.id
      return "Not Assigned"
    end
    "[#{self.end_date}] #{self.title}"
  end

  def is_current?
    self.id == Project.find(self.project_id).current_milestone.id
  end

  def date_state_in_words
    if self.is_current?
      return "current"
    elsif self.passed?
      return "past"
    else
      return "future"
    end
  end

end
