class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user

  private
    def authenticate_admin_user!
      redirect_to root_path  unless current_user.try(:is_admin?)
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
    
    def authenticate_user
      redirect_to root_path if current_user.nil?
    end
end
