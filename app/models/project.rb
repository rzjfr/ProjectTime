class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_member, dependent: :destroy
  has_many :milestone, dependent: :destroy
  has_many :task, dependent: :destroy
  validates :description, length: { maximum: 200 }
  validates :name, length: { maximum: 20 }, presence: true
  validates :user_id, presence: true
  validate :uniqueness_in_scope
  before_save { self.name = self.name.downcase }
  after_create {
    self.add_project_member(User.find(self.user_id), self)
    Milestone.create(title: (self.name + " project start"),
                     date: self.created_at.to_date, project_id: self.id)
  }

  def uniqueness_in_scope
    if User.find(self.user_id).projects.where(name: self.name.downcase).present?
      errors.add(:name, ': you have already created a project with that name.')
    end
  end

  def add_project_member(user, project)
    ProjectMember.create(project_id: project.id, user_id: user.id,
                         owner: (project.user_id == user.id))
  end

  def remove_project_member(user, project)
    ProjectMember.find_by(project_id: project.id, user_id: user.id).destroy
  end

  def last_milestone
    Project.find(self.id).milestone.order(:end_date).first
  end

  def first_milestone
    Project.find(self.id).milestone.order(:end_date).last
  end

  def current_milestone
    Project.find(18).milestone.where('end_date <= (?)',
                                     Date.today).order(:end_date).first
  end
end
