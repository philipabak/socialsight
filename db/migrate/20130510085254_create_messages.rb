class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :message_thread
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.text :message_text, :null => false
      t.integer :modified_booking_id
      t.string :status, :default => "UNREAD", :null => false
      t.timestamps
    end
  end
end
