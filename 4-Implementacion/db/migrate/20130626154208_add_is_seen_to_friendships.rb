class AddIsSeenToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :is_seen, :boolean, :default => false
  end
end
