class CreateProjectConversations < ActiveRecord::Migration
  def change
    create_table :project_conversations do |t|
      t.string :content
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :project_conversations, :projects
    add_foreign_key :project_conversations, :users
  end
end
