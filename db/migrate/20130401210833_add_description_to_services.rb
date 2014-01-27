class AddDescriptionToServices < ActiveRecord::Migration
  def change
    add_column :services, :description, :text, limit: nil
  end
end
