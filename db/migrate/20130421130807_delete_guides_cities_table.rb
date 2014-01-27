class DeleteGuidesCitiesTable < ActiveRecord::Migration
  def up
  	drop_table :guides_cities  
  end

  def down
  	create_table :guides_cities, :id => false do |t|
      t.references :guide
      t.references :city
    end
    add_index :guides_cities, [:guide_id, :city_id]
  end
end
