class AddTitleDigestToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :title_digest, :string
  end
end
