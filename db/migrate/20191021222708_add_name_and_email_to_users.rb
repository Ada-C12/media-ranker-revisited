class AddNameAndEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :email, :string
    add_column :users, :nickname, :string
  end
end
