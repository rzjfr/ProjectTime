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

  settings index: {
    number_of_shards: 1,
    number_of_replicas: 0 ,
    analysis: {
      filter: {
          conversation_filter: {
              type: "word_delimiter",
              type_table: ["# => ALPHA", "@ => ALPHA"]
          }
      },
      analyzer: {
          conversation_analyzer: {
              type: "custom",
              tokenizer: "whitespace",
              filter: ["lowercase", "conversation_filter"]
          }
      }
    }
  }

  mappings dynamic: 'false' do
    indexes :content, type: "string", analyzer: 'conversation_analyzer', index_options: 'offsets', analyze_wildcard: true
    indexes :project_id, type: "long"
    indexes :user_id, type: "string"
    indexes :created_at, type: 'date'
  end

  def self.search(query, project_id, user_id, fuzzy, options={})
    __elasticsearch__.search(
      {
        query: {
          filtered: {
            query: {
              multi_match: {
                query: query,
                fields: ['content^10'],
                #fuzziness: 2,
                operator: "AND"
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
          pre_tags: ['<em class="search-em">'],
          post_tags: ['</em>'],
          fields: {
            content: {}
          }
        }
      },
      #size: options[:per_page],
      #from: options[:from]
      #sort: [ { content: {order: "asc"}} ]
    )
  end
end

ProjectConversation.import
