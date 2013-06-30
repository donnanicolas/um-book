class AddFileToPhotos < ActiveRecord::Migration
  def self.up
    add_attachment :photos, :file
  end

  def self.down
    remove_attachment :photos, :file
  end
end
