class CreateUsersCitiesTable < ActiveRecord::Migration
  def up
  	create_table :users_cities, :id => false  do |t|
      t.references :user
      t.references :city
    end
    add_index :users_cities, [:user_id, :city_id]
    add_index :users_cities, [:city_id, :user_id]
  end

  def down
  	drop_table :users_cities
  end
end
