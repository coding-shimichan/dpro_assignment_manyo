class AddPriorityToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :priority, :integer, default: 1, null: false
  end
end
