class ChangeGuidesRateToNotNullable < ActiveRecord::Migration
  def up
    change_column :guides, :rate, :float, default: 0.0, null: false
  end

  def down
    change_column :guides, :rate, :float, null: true
  end
end
