class CreateLocationSearches < ActiveRecord::Migration
  def change
    create_table :location_searches do |t|
      t.string  :query, null: false
      t.integer :search_count, null: false, default: 0

      t.timestamps
    end

    add_index :location_searches, [:query]
  end
end
