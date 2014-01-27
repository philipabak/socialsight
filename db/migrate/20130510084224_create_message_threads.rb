class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.boolean :deleted_by_sender, :default => false
      t.boolean :deleted_by_receiver, :default => false
      t.timestamps
    end
  end
end
