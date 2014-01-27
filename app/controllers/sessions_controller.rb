class SessionsController < ApplicationController
  skip_before_filter :authenticate_user

  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      reponse = {result: 'success', url: request.referer}
    elsif user
      reponse = {result: 'failure', msg: 'invalid password!'}
    else
      reponse = {result: 'failure', msg: 'invalid email!'}
    end

    respond_to {|format| format.js {render json: reponse}}
  end

  def create_fb
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to request.referer   
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url#, notice: "Logged out!"
  end
end
