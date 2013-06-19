class Photo < ActiveRecord::Base
  attr_accessible :album_id, :description

  belongs_to :album
end
