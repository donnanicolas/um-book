class Photo < ActiveRecord::Base
  attr_accessible :album_id, :description, :file

  belongs_to :album
  has_attached_file :file, styles: { medium: "800x800>" }, :default_url => "/images/:style/missing.png"
  
  validates_attachment :file, :presence => true,
    :content_type => { :content_type => "image/jpeg" },
    :size => { :in => 0..3.megabytes }
end
