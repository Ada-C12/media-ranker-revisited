class AddWorksUsersRelationship < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :work, foreign_key: true
  end
end
