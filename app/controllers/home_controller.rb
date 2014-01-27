class HomeController < ApplicationController
  skip_before_filter :authenticate_user

  def index
    @popular_cities = City.top5
    @rnd_guides     = Guide.get_random_guides_with_pos_review
  end
end
