class CreateGuidesTransportationMethodsTable < ActiveRecord::Migration
  def up
    create_table :guides_transportation_methods, :id => false do |t|
      t.references :guide
      t.references :transportation_method
    end
    add_index :guides_transportation_methods,
              [:guide_id, :transportation_method_id],
              :unique => true, :name => 'guides_transportation_methods_index'
  end

  def down
    drop_table :guides_transportation_methods
  end
end
