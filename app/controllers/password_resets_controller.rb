class PasswordResetsController < ApplicationController
  skip_before_filter :authenticate_user
  
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_path, flash:{success: 'An email has been sent with further instructions for password reset!
                                            You have 2 hours to reset the password or ask for a new reset!'}
  end

  def edit
    return root_path if params[:id].nil?
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to root_url, flash:{error: "Password reset has expired! Please ask for a new reset!"}
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, flash:{success: 'Password successfully reset!'}
    else
      render :edit
    end
  end
end
