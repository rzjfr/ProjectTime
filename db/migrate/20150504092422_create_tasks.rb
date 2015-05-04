class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project, index: true
      t.string :title
      t.string :description
      t.references :milestone, index: true
      t.integer :estimate
      t.integer :milestone_id
      t.integer :creator_id
      t.integer :assignee_id
      t.string :state

      t.timestamps null: false
    end
    add_foreign_key :tasks, :projects
    add_foreign_key :tasks, :milestones
  end
end
