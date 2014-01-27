class AddIsPhoneVerifiedToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :is_phone_verified, :boolean, default: false, null: false
  end
end
