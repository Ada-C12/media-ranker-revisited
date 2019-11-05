class RemoveIncorrectRelationship < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :work_id
    add_reference :works, :user, foreign_key: true
  end
end
