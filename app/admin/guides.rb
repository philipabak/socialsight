ActiveAdmin.register Guide do
  controller do
    with_role :admin
    def scoped_collection
      Guide.includes(:user, spoken_languages: [:language,:language_level])
    end
  end

  index do
    column "Avatar" do |guide|
      link_to(image_tag(guide.user.avatar.url(:thumb)))
    end

    column :id
    column 'User id'    do |guide| guide.user.id end
    column 'First name' do |guide| guide.user.first_name end
    column 'Last name'  do |guide| guide.user.last_name end
    column 'Gender'     do |guide| guide.user.sex end
    column 'Birth date' do |guide| guide.user.birth_date end
    column :rate
    column "Professional",   :is_professional
    column "Phone Verified", :is_phone_verified
    column 'FB friends'    do |guide| guide.user.fb_friend_count end
    column :completeness_score 
    column :spoken_languages_with_levels
    column :short_introduction
    default_actions
  end

  show :title => 'Guide information' do
    attributes_table do
      row 'email'         do guide.user.email end
      row 'First name'    do guide.user.first_name end
      row 'Last name'     do guide.user.last_name end
      row 'Gender'        do guide.user.sex end
      row 'Birth date'    do guide.user.birth_date end
      row :rate
      row "Professional"   do guide.is_professional   end
      row "Phone Verified" do guide.is_phone_verified end
      row :spoken_languages_with_levels
      row :short_introduction
      row :long_introduction
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs :name => "User information", :for => [:user, f.object.user || User.new] do |uf|
      uf.input :email
      uf.input :password
      uf.input :first_name
      uf.input :last_name
      uf.input :sex, :as => :select, collection: User::GENDERS, include_blank: false
      uf.input :birth_date, start_year: 1910, end_year:2010
      uf.input :is_admin
      uf.input :avatar, :as => :file,  :hint => "current image:
                  #{uf.template.image_tag(uf.object.avatar.url(:thumb))}"
    end

    f.inputs "Guide information" do
      f.input :is_professional,   label: "Professional"
      f.input :is_phone_verified, label: "Phone Verified"
      f.input :short_introduction
      f.input :long_introduction
      f.input :rate, as: :string
    end

    f.inputs :spoken_languages do
      f.has_many :spoken_languages do |sl|
        sl.inputs do
          sl.input :language,       include_blank: false
          sl.input :language_level, include_blank: false
          sl.input :_destroy,       as: :boolean
        end
      end
    end

    f.inputs do
      f.input :services, as: :check_boxes
    end

    f.inputs do
      f.input :interests, as: :check_boxes
    end

    f.inputs do
      f.input :transportation_methods, as: :check_boxes
    end

    f.actions
  end

  actions :all#, except: [:destroy]
end
