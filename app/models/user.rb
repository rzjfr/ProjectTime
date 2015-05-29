class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :authentication_keys => [:login]
  has_many :projects, dependent: :destroy
  has_many :project_conversation, dependent: :destroy
  has_many :message, dependent: :destroy
  has_many :recived, class_name: "Message", foreign_key: "reciver_id", dependent: :destroy
  has_many :task, class_name: "Task", foreign_key: "creator_id"
  has_many :assigned, class_name: "Task", foreign_key: "assignee_id"
  validates :username, uniqueness: { case_sensitive: false }, presence: true, length: {minimum: 3, maximum: 10}

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value",
                                    { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

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

  def self.search(query, options={})
    __elasticsearch__.search(
      {
        query: {
            multi_match: {
            query: query,
            fields: ['username^10', 'email'],
            operator: "AND"
            }
        },
      },
    )
  end

  settings index: {
    number_of_shards: 1,
    number_of_replicas: 0,
    analysis: {
      filter: {
            autocomplete_filter: {
                type:     "edge_ngram",
                min_gram: 1,
                max_gram: 20
            }
      },
      analyzer: {
        autocomplete: {
            type: "custom",
            tokenizer: "standard",
            filter: ["lowercase", "autocomplete_filter"]
        }
      }
    }
  }

  mappings dynamic: 'false' do
    indexes :username, type: "string", analyzer: "autocomplete"
    indexes :email, type: "string"
    indexes :id, type: "long"
  end

  def as_indexed_json(options={})
    as_json(
      only: [:id, :username, :email]
    )
  end


end

User.import
