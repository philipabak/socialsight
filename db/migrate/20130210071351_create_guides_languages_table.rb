class CreateGuidesLanguagesTable < ActiveRecord::Migration
  def self.up
    create_table :guides_languages, :id => false do |t|
      t.references :guide
      t.references :language
    end
    add_index :guides_languages, [:guide_id, :language_id]
  end

  def self.down
    drop_table :guides_languages
  end
end
