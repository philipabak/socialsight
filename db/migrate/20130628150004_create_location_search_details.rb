class CreateLocationSearchDetails < ActiveRecord::Migration
  def change
    create_table :location_search_details do |t|
      t.string :ip, null: false
      t.integer :user_id
      t.integer :location_search_id, null: false

      t.timestamps
    end
  end
end
