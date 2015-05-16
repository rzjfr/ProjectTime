class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :project_conversation, index: true
      t.references :user, index: true
      t.integer :reciver_id

      t.timestamps null: false
    end
    add_foreign_key :messages, :users
    add_foreign_key :messages, :project_conversations
  end
end
