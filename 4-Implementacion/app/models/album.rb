class Album < ActiveRecord::Base
  attr_accessible :name, :user_id

  has_many :photos, dependent: :destroy
  belongs_to :user
end
