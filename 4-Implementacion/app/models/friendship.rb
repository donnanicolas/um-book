class Friendship < ActiveRecord::Base
  attr_accessible :are_friends, :user_a_id, :user_b_id
  validates_presence_of :are_friends, :user_a_id, :user_b_id
  
  belongs_to :user_a, class_name: :User
  belongs_to :user_b, class_name: :User
end
