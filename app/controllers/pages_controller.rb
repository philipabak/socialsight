class PagesController < ApplicationController
  skip_before_filter :authenticate_user, except: [:guide_registration_thankyou]
  
  def how_it_works
  end
  def terms_of_use
  end
  def privacy_policy
  end
  def why_join_as_a_guide
  end
  
  def why_join_as_a_professional_guide
  end

  def guide_registration_thankyou
  	if current_user.guide.nil?
  	  redirect_to edit_guide_path
  	end
  end
end