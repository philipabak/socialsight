class AddAttachmentImageToGuideImages < ActiveRecord::Migration
  def self.up
    change_table :guide_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :guide_images, :image
  end
end
