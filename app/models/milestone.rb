class Milestone < ActiveRecord::Base
  belongs_to :project
  default_scope { order('end_date DESC') }
  validates :title, length: { maximum: 200 }, presence: true
  validates :end_date, uniqueness: {scope: :project_id}, presence: true
  validate :valid_end_date

  def valid_end_date
    if end_date.present? && (end_date < Date.today)
      errors.add(:end_date, 'must be a passed date.')
    end
  end

  def passed?
    self.end_date <= Date.today
  end
end
