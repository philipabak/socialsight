class AddAvgRatingToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :avg_rating, :float
  end
end
