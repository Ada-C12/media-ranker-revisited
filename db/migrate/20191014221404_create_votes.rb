class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :work_id
      t.integer :user_id
      t.datetime :date

      t.timestamps
    end
  end
end
