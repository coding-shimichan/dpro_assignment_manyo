class AddUniqueIndexToLabels < ActiveRecord::Migration[6.1]
  def change
    remove_index :labels, :user_id if index_exists?(:labels, :user_id)
    add_index :labels, [:user_id, :name], unique: true, name: "index_labels_on_user_id_and_name"
  end
end
