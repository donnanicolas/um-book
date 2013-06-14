class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :born_at, :profile_picture_id
  validates_presence_of :first_name, :last_name, :born_at
end
