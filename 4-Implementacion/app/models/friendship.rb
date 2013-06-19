class Friendship < ActiveRecord::Base
  attr_accessible :are_friends, :user_a_id, :user_b_id
  validates_presence_of :user_a_id, :user_b_id
  
  belongs_to :user_a, class_name: :User
  belongs_to :user_b, class_name: :User

  def self.find_by_users(user_a_id, user_b_id)
    Friendship.where("(user_a_id = ? AND user_b_id = ?) OR (user_b_id = ? AND user_a_id = ?)", user_a_id, user_b_id, user_a_id, user_b_id).first
  end

  def self.are_users_friends?(user_a_id, user_b_id)
    @fr = self.find_by_users(user_a_id, user_b_id)
    @fr && @fr.are_friends?
  end
end
