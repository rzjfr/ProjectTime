class Project < ActiveRecord::Base
  belongs_to :user
  validates :description, length: { maximum: 200 }, presence: true
  validates :name, length: { maximum: 20 }, presence: true
  validates :user_id, presence: true

end
