class AddRatingToComments < ActiveRecord::Migration
  def change
    add_column :comments, :rating, :int
  end
end
