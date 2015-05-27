require 'elasticsearch/model'

class ProjectConversation < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :project
  belongs_to :user
  has_many :message
  validates :content, length: { maximum: 320 }
  default_scope ->{ order('created_at DESC') }
  paginates_per 11

  after_save {
    ApplicationController.helpers.all_relative_ids(self).each do |id|
      Message.create({project_conversation_id: self.id,
                      user_id: self.user_id, reciver_id: id})
    end
  }

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :content, analyzer: 'english'
    end
  end

  def self.search(query, project_id, user_id, options={})
    #byebug
    #options[:per_page] ||= 10
    #options[:from] = options[:page] * options[:per_page]
    __elasticsearch__.search(
      {
        query: {
          filtered: {
            query: {
              multi_match: {
                query: query,
                fields: ['content'],
              operator: "and"
              }
            },
            filter: {
              bool: {
                must: [
                  {term: { project_id: project_id }},
                  {terms: { user_id: user_id }}
                ]
              }
            },
            strategy: 'leap_frog_filter_first'
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            content: {}
          }
        }
      },
      #size: options[:per_page],
      #from: options[:from]
    )
  end
end

ProjectConversation.import
