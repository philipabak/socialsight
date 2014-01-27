class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country_name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
