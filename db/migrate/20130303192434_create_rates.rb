class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :guide_id
      t.integer :service_id
      t.float :rate

      t.timestamps
    end
  end
end
