class GuidesController < ApplicationController
  skip_before_filter :authenticate_user, only: [:show]

  def show
    @guide = Guide.includes(:services, :user, :interests, comment_threads: :user,
        rates: :service, spoken_languages: [:language, :language_level]).find(params[:guidename])
    @city = @guide.cities.first
    @breadcrumbs = [{name: @city.name,             link: @city.slug},
                    {name: @guide.user.short_name, link: @guide.slug}]            
    @comment = Comment.new
  rescue ActiveRecord::RecordNotFound
    logger.warn "Trying to find #{params[:guidename]} redirect to root"
    redirect_to root_path
  end

  def edit
    @user  = current_user
    # Set default language for new guides
    if @user.guide.nil?
      @guide = Guide.new
      @guide.add_spoken_language('English','Intermediate')
      @guide.user = @user
    else
      @guide = @user.guide 
    end
    3.times { @guide.guide_images.build }
  end

  def create
    guide = Guide.new
    guide.user = current_user
    update_guide_and_send_profilecomplete_mail(guide, params)
  end

  def update
    guide = current_user.guide
    update_guide_and_send_profilecomplete_mail(guide, params)
  end

  private
  def update_guide_and_send_profilecomplete_mail(guide, params)  
    if guide.update_attributes(params[:guide])
      #Update guide cache
      guide.set_city_via_params(params)
      City.update_guide_cache_for_cities(guide.user.cities)

      # send welcome mail and redirect to welcome page
      if guide.completeness_score==100 && !guide.is_regmail_sent
        GuideMailer.profile_complete_mail(guide).deliver
        guide.is_regmail_sent = true
        guide.save
        # Promote to guide newsletter on production env
        if Rails.env.production?
          begin
            mailchimp = MailchimpService.new
            mailchimp.subscribe_user_to_list(guide.user, 'Guide')
          rescue Gibbon::MailChimpError => ex
            logger.error(ex)
          end
        end
        return redirect_to guide_registration_thankyou_path 
      end 

      if guide.completeness_score==100
        flash[:success] = "Profile updated. You can visit your guide profile page by <a href=\"#{guide.link}\">clicking here.</a>".html_safe
      else
        flash[:success] = "Profile updated successfully!"
      end
      
    else
      flash[:error] = "Oops"
    end
    redirect_to edit_guide_path
  end
end