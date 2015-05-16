class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects, dependent: :destroy
  has_many :project_conversation, dependent: :destroy
  has_many :message, dependent: :destroy
  has_many :recived, class_name: "Message", foreign_key: "reciver_id", dependent: :destroy

  def admin?
    self.admin
  end

  def member_projects
    Project.where('id in (?)', ProjectMember.where('user_id in (?)',
                                                   self.id).pluck(:project_id))
  end

  def owned_projects_ids
    self.projects.pluck(:id)
  end

  def member_projects_ids
    self.member_projects.pluck(:id)
  end

end
