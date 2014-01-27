class AddFbFriendCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_friend_count, :int
  end
end
