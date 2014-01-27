class CreateGuideImages < ActiveRecord::Migration
  def change
    create_table :guide_images do |t|
      t.integer :guide_id

      t.timestamps
    end
  end
end
