ActiveAdmin.register LocationSearch do
  config.sort_order = "search_count_desc"

  index do
    column :id
    column :query
    column :search_count
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :query      
      row :search_count
      row :created_at
      row :updated_at
    end

    panel 'Details' do
      table_for location_search.location_search_detail.order('id desc') do
        column :id
        column :ip
        column :user
        column :created_at
      end
    end
  end  

  actions :index, :show
end