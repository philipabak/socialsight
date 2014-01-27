class AddGuideIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guide_id, :int
  end
end
