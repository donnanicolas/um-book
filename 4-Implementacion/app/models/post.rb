class Post < ActiveRecord::Base
  attr_accessible :content, :user_a_id, :user_b_id
  validates_presence_of :content, :user_a_id, :user_b_id
 
  belongs_to :user_sender, class_name: :User
  belongs_to :user_receiver, class_name: :User
  
end
