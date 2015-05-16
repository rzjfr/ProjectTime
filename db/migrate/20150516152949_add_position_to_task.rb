class AddPositionToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_class, :string
  end
end
