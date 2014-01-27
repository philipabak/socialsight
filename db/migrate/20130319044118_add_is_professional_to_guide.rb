class AddIsProfessionalToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :is_professional, :boolean
  end
end
