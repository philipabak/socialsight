class DropOutdatedGuidesLanguages < ActiveRecord::Migration
  def up
    drop_table :guides_languages
  end

  def down
    create_table :guides_languages, :id => false do |t|
      t.references :guide
      t.references :language
    end
    add_index :guides_languages, [:guide_id, :language_id]
  end
end
