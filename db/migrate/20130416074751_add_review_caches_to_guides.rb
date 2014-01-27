class AddReviewCachesToGuides < ActiveRecord::Migration
  def up
  	add_column 		:guides, :positive_review_count, :integer, default: 0, null: false
  	add_column 		:guides, :negative_review_count, :integer, default: 0, null: false
  	add_column 		:guides, :positive_review_proportion, :float, default: 0, null: false
  	remove_column :guides, :avg_rating
  end

  def down
  	remove_column :guides, :positive_review_count
  	remove_column :guides, :negative_review_count
  	remove_column :guides, :positive_review_proportion
  	add_column 		:guides, :avg_rating, :float
  end
end
