class CitiesController < ApplicationController
  skip_before_filter :authenticate_user

	def city_search
		#Default value for city search
    params[:city_search] ||= request.location.city
    params[:city_search] = "Budapest" if params[:city_search].blank?
    #Find nearest city in 10 mile radious
    @city = City.near(params[:city_search], 10, order: "distance").first

    #save search query
    LocationSearch.create_with_detail params[:city_search], current_user, request.remote_ip

    #Redirect if none found
    if @city
    	redirect_to "/#{@city.slug}"
    else
    	redirect_to city_not_found_path(city_search: params[:city_search])
    end
	end

  def show
    @city = City.find(params[:cityname])
    #Filter user attributes
    users = @city.users
    users = users.guides
    users = users.male if params[:gender]=="Male"
    users = users.female if params[:gender]=="Female"

    unless params[:age_group].blank?
      age_group  = params[:age_group].split "-"
      users = users.age_between(age_group[0], age_group[1])
    end

    #Filter guide attributes
    #Join users and guides
    user_ids = users.map{|u| u.guide_id}
    @guides = Guide.can_guide.where("guides.id IN (?)", user_ids)
    #Filter languages
    @guides = @guides.joins(:languages).where(languages:{id: params[:language] }) unless params[:language].blank?

    #Filter interests
    @guides = @guides.joins(:interests).where(interests:{id: params[:interest] }) unless params[:interest].blank?

    #Sorting
    @guides = @guides.includes(:user).order("users.birth_date DESC") if params[:sort_by] == "Age"
    @guides = @guides.order("positive_review_proportion IS NULL, positive_review_proportion DESC") if params[:sort_by] == "Rating"

    #Pagination
    @guides = @guides.includes(:spoken_languages, :languages).page(params[:page]).per(20)

    #Language options
    @languages = Language.priority_list('English', 'Spanish','German','French')

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
    end
  end

  def not_found
    @not_found_location = params[:city_search]
    @cities = City.where('guides_count>0').closest_cities(params[:city_search], 9)
    @guides = @cities.map {|c| c.featured_guide}  
  end
end