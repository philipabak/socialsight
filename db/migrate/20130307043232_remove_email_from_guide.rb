class RemoveEmailFromGuide < ActiveRecord::Migration
  def up
    remove_column :guides, :email
  end

  def down
    add_column :guides, :email, :string
  end
end
