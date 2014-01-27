class CreateTransportationMethods < ActiveRecord::Migration
  def change
    create_table :transportation_methods do |t|
      t.string :name

      t.timestamps
    end
  end
end
