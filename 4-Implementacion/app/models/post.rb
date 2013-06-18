class Post < ActiveRecord::Base
  attr_accessible :content, :user_a_id, :user_b_id
  validates_presence_of :content, :user_a_id, :user_b_id
 
  belongs_to :user_sender, foreign_key: :user_a_id, class_name: :User
  belongs_to :user_receiver, foreign_key: :user_b_id, class_name: :User

  default_scope order('created_at DESC')
end
