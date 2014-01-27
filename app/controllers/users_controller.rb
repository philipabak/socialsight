class UsersController < ApplicationController
  skip_before_filter :authenticate_user, only: [:new, :create]

  def new
    @user = User.new
  end


  def create
    @user = User.new params[:user]
    city = City.find_or_initialize_by_name_and_country_name(params[:city])
    @user.cities = [city]

    if @user.save
      session[:user_id] = @user.id
      redirect_to edit_guide_path, flash: {success: 'Thank you for signing up!'}
    else
      msg = 'Oops something has went wrong!'
      msg = 'Email address is already taken!' if @user.errors.messages[:email].present?
      redirect_to root_url, flash: {error: msg}
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Your changes have been saved!'
    else
      flash[:error] = 'Oops! There was some problem with the update!'
    end
    render 'edit'
  end

  def edit
    @user = current_user
  end
end
