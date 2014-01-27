class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :message, :null => false
      t.references :user, :null => false
      t.references :guide, :null => false
      t.integer :price, :null => false
      t.string :status, :default => 'OFFERED'
      t.timestamps
    end
  end
end
