class CreateSpokenLanguages < ActiveRecord::Migration
  def change
    create_table :spoken_languages do |t|
      t.references :guide
      t.references :language
      t.references :language_level

      t.timestamps
    end
  end
end
