class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.references :project, index: true
      t.string :title
      t.date :end_date

      t.timestamps null: false
    end
    add_foreign_key :milestones, :projects
  end
end
