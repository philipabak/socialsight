class AddIconCssClassToServices < ActiveRecord::Migration
  def change
    add_column :services, :icon_css_class, :string
  end
end
