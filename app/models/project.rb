class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_member, dependent: :destroy
  validates :description, length: { maximum: 200 }, presence: true
  validates :name, length: { maximum: 20 }, presence: true
  validates :user_id, presence: true
  validate :uniqueness_in_scope
  before_save { self.name = self.name.downcase }

  def uniqueness_in_scope
      if User.find(self.user_id).projects.where(name: self.name.downcase).present?
      errors.add(:name, ': you have already created a project with that name.')
    end
  end

  def add_project_member(user, project)
      ProjectMember.create(project_id: project.id, user_id: user.id, owner: project.user_id)
  end

  def remove_project_member(user, project)
      ProjectMember.find_by(project_id: project.id, user_id: user.id).destroy
  end

end
