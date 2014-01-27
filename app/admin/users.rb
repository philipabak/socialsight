ActiveAdmin.register User do
  controller { with_role :admin }

  controller do
    def scoped_collection
      User.includes(:guide, :cities)
    end
  end

  filter :email
  filter :created_at
  filter :updated_at
  filter :is_admin

  index do
    column "Avatar" do |user|
      link_to(image_tag(user.avatar.url(:thumb)))
    end

    column :id
    column :guide
    column :email
    column :first_name
    column :last_name
    column :sex
    column :birth_date
    column :is_admin
    column :fb_friend_count
    column 'Completeness score' do |user| user.guide.present? ? user.guide.completeness_score : "" end
    column 'Cities'             do |user| user.cities.map{|c| c.name}.to_sentence end
    column :updated_at
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :sex
      row :birth_date
      row :is_admin
      row :fb_friend_count
      row :updated_at
      row :created_at
    end
  end

  form do |f|
    f.inputs "Add/Edit User" do
      if f.object.new_record?
        f.input :email
      end
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :is_admin 
      f.input :sex,       :as => :select, :collection => User::GENDERS, include_blank: false
      f.input :birth_date, start_year: 1910, end_year:Time.now.year-14
      f.input :avatar, :as => :file,  :hint => "current image:
                  #{f.template.image_tag(f.object.avatar.url(:thumb))}"
    end
    f.actions
  end

  actions :all#, except: [:destroy]
end
