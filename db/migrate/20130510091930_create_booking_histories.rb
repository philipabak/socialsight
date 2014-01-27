class CreateBookingHistories < ActiveRecord::Migration
  def change
    create_table :booking_histories do |t|
      t.references :booking, :null => false
      t.integer :user_id, :null => false
      t.string :old_status
      t.string :new_status
      t.datetime :date      
    end
  end
end
