class CreateProjectMembers < ActiveRecord::Migration
  def change
    create_table :project_members do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.boolean :owner

      t.timestamps null: false
    end
    add_foreign_key :project_members, :projects
    add_foreign_key :project_members, :users
  end
end
