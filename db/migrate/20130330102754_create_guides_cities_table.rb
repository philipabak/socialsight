class CreateGuidesCitiesTable < ActiveRecord::Migration
  def up
    create_table :guides_cities, :id => false do |t|
      t.references :guide
      t.references :city
    end
    add_index :guides_cities, [:guide_id, :city_id]
  end

  def down
    drop_table :guides_cities
  end
end
