class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :born_at, :profile_photo
  validates_presence_of :first_name, :last_name, :born_at

  has_many :friendships, foreign_key: :user_a_id, dependent: :destroy
  has_many :users, through: :friendships, source: :user_b
  has_many :reverse_friendships, class_name: :Friendship, foreign_key: :user_b_id, dependent: :destroy
  
  has_many :sent_posts, foreign_key: :user_a_id, class_name: :Post, dependent: :destroy
  has_many :received_posts, foreign_key: :user_b_id, class_name: :Post, dependent: :destroy
  has_many :albums
  has_attached_file :profile_photo, styles: { thumb: "100x100>", medium: "800x800>" }, :default_url => "default.png"

  validates_attachment :profile_photo,
    :content_type => { :content_type => "image/jpeg" },
    :size => { :in => 0..500.kilobytes }
  
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
      if post.is_home_post? || Friendship.are_users_friends?(post.user_receiver.id, post.user_sender.id)
        posts << post
      end
    end

    posts.sort_by { |p| p[:created_at] }.reverse
  end

  def profile_posts
    posts = []

    received_posts.each do |post|
      posts << post
    end

    posts.sort_by { |p| p[:created_at] }.reverse
  end

  def friendships_not_read
    reverse_friendships.where(is_seen: false)
  end

  def friendships_not_accepted
    reverse_friendships.where(are_friends: false)
  end

  def mark_solicitudes_as_read
    reverse_friendships.where(is_seen: false).each do |s|
      s.is_seen = true
      s.save
    end
  end

  def to_s
    self.first_name + " " + self.last_name
  end

  def self.search(query)
    query = '%' + query + '%'
    User.where("first_name LIKE (?) OR last_name LIKE (?)", query, query)    
  end
end
