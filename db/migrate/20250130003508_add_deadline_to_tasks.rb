class AddDeadlineToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline_on, :date, default: -> { 'CURRENT_DATE' }, null: false
  end
end
