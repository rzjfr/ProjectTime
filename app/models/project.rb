class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_member, dependent: :destroy
  has_many :project_conversation, dependent: :destroy
  has_many :task, dependent: :destroy
  has_many :milestone, dependent: :destroy
  validates :description, length: { maximum: 100 }
  validates :name, length: { maximum: 20 }, presence: true
  validates :user_id, presence: true
  validate :uniqueness_in_scope

  before_save { self.name = self.name.downcase }

  after_create {
    self.add_project_member(User.find(self.user_id), self)
    Milestone.create(title: (self.name + " project start"),
                     end_date: self.created_at.to_date,
                     project_id: self.id)
  }

  def uniqueness_in_scope
    if User.find(self.user_id).projects.where(name: self.name.downcase).present?
      errors.add(:name, ': you have already created a project with that name.')
    end
  end

  def add_project_member(user, project)
    if user.nil?
      errors.add(:user, ': no user with that username.')
    else
      ProjectMember.create(project_id: project.id, user_id: user.id,
                           owner: (project.user_id == user.id))
    end
  end

  def remove_project_member(user, project)
    ProjectMember.find_by(project_id: project.id, user_id: user.id).destroy
  end

  def last_milestone
    self.milestone.order(:end_date).last
  end

  def first_milestone
    self.milestone.order(:end_date).first
  end

  def uses_milestones?
    self.milestone.count != 1
  end

  def current_milestone_end_date
    if self.uses_milestones?
      return self.current_milestone.end_date
    else
      return Date.today
    end
  end

  def current_milestone_start_date
    if self.uses_milestones?
      return self.milestone.where('end_date <= (?)', Date.today).order(:end_date).last.end_date
    else
      return first_milestone.end_date
    end
  end

  def current_milestone
    if self.uses_milestones?
      return self.milestone.where('end_date >= (?) and id != (?)', Date.today,
                                  first_milestone.id).order(:end_date).first
    else
      return self.milestone.order(:end_date).last
    end
  end

  def changed_tasks_id
    self.task.each.map { |x| x.id if !x.last_changes.nil? }.compact
  end

  def members_ids
    self.project_member.pluck(:user_id)
  end

  def members
    User.where("id in (?)", self.project_member.pluck(:user_id))
  end

  def start_time
    self.first_milestone.created_at
  end

end
