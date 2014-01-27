ActiveAdmin.register Comment, :as => "Review" do
	controller { with_role :admin }

	controller do
    def scoped_collection
      Comment.includes(:user, commentable: [:user])
    end
  end

	filter :body, label: 'Review Text'
	filter :rating, label: 'Rating', as: :select,
	    				collection: { 'Positive' => 1, 'Negativ' => -1 },
	    				include_blank: false

  index do
    column :id

  	column "Commenter" do |comment|
  		commenter_path = comment.user.is_guide? ?
  								admin_guide_path(comment.user) :
  								admin_user_path(comment.user) 

  		link_to(image_tag(
	      comment.user.avatar.url(:thumb)),
	      commenter_path
	    )
    end

    column "Commented on" do |comment|
    	link_to(image_tag(
	      comment.commentable.user.avatar.url(:thumb)),
	      admin_guide_path(comment.commentable)
	    )
    end

    column "Rating" do |comment|
    	comment.rating == 1 ? 'Positive' : 'Negativ'
    end

    column "Review" do |comment| comment.body end
    default_actions
  end

  show do
    attributes_table do
      row 'Review' do review.body end
      row 'Rating' do review.rating == 1 ? 'Positive' : 'Negativ' end
    end
  end

  form do |f|
  	f.inputs do
	    f.input :body, label: 'Review'
	    f.input :rating, label: 'Rating', as: :select,
	    				collection: { 'Positive' => 1, 'Negativ' => -1 },
	    				include_blank: false
  	end
  	f.actions
  end

  actions :all, :except => [:new]
end