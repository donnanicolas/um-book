class RemoveProfilePictureIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :profile_picture_id
  end

  def down
    add_column :users, :profile_picture_id, :integer
  end
end
