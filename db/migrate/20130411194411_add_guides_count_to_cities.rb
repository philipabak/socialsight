class AddGuidesCountToCities < ActiveRecord::Migration
  def change
    add_column :cities, :guides_count, :integer, default: 0, null: false
  end
end
