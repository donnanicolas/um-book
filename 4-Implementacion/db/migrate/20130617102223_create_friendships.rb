class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_a_id, :null => false
      t.integer :user_b_id, :null => false
      t.boolean :are_friends, :default => false

      t.timestamps
    end
  end
end
