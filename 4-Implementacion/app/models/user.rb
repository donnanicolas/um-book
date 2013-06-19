class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :born_at, :profile_picture_id
  validates_presence_of :first_name, :last_name, :born_at

  has_many :friendships, foreign_key: :user_a_id, dependent: :destroy
  has_many :users, through: :friendships, source: :user_b
  has_many :reverse_friendships, class_name: :Friendship, foreign_key: :user_b_id, dependent: :destroy
  
  has_many :sent_posts, foreign_key: :user_a_id, class_name: :Post, dependent: :destroy
  has_many :received_posts, foreign_key: :user_b_id, class_name: :Post, dependent: :destroy


  def friends
    friends_list = []
    
    friendships.where(are_friends: true).each do |f| 
      friends_list << f.user_b
    end

    reverse_friendships.where(are_friends: true).each do |f| 
      friends_list << f.user_a
    end

    return friends_list
  end

  def home_posts
    posts = []

    friends.each do |friend|
      friend.sent_posts.each do |post|
        posts << post
      end
    end

    sent_posts.each do |post|
      posts << post
    end

    posts.sort_by { |p| p[:created_at] }.reverse
  end

  def to_s
    self.first_name + " " + self.last_name
  end
end
