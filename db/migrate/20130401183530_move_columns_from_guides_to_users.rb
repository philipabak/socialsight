class MoveColumnsFromGuidesToUsers < ActiveRecord::Migration
  def up
    add_column :users,     :first_name, :string
    add_column :users,     :last_name,  :string
    add_column :users,     :birth_date, :date
    add_column :users,     :sex,        :string
    remove_column :guides, :first_name
    remove_column :guides, :last_name 
    remove_column :guides, :birth_date 
    remove_column :guides, :sex 
  end

  def down
    add_column :guides,   :first_name,  :string
    add_column :guides,   :last_name,   :string
    add_column :guides,   :birth_date,  :date
    add_column :guides,   :sex,         :string
    remove_column :users, :first_name
    remove_column :users, :last_name 
    remove_column :users, :birth_date 
    remove_column :users, :sex    
  end
end
