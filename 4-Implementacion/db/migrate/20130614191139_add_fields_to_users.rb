class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :born_at, :date
    add_column :users, :profile_picture_id, :integer
  end
  
end
