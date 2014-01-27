ActiveAdmin.register City do
	index do
    column :id
    column :name
    column :country_name
    column :guides_count
    column :longitude
    column :latitude
    column :created_at
    column :updated_at
    default_actions
  end

  show  do
    attributes_table do
      row :id
      row :name
      row :country_name
      row :guides_count
    end

		panel 'Guides' do
			table_for city.users do
		    column 'User Id'	  do |user| link_to(user.id, admin_user_path(user)) end
        column 'Guide Id'   do |user| user.is_guide? ? link_to(user.guide.id, admin_guide_path(user.guide)) : "" end
		    column 'First name' do |user| user.first_name end
		    column 'Last name'  do |user| user.last_name end
		    column 'Gender'     do |user| user.sex end
		    column 'Birth date' do |user| user.birth_date end
			end
		end
  end

	actions :index, :show
end