class NewsletterController < ApplicationController
  skip_before_filter :authenticate_user

  def signup
    mailchimp = MailchimpService.new
    mailchimp.subscribe_email_to_list(params[:email])
    flash[:success] = 'You have successfully signed up for the Newsletter! Hurray!'
    redirect_to root_path
  rescue Gibbon::MailChimpError => ex
    case ex.exception.code
    when 214
      flash[:notice] = 'You are already on the mailing list!'
    when 502
      flash[:error] = 'Sadly the provided email address is invalid! Please check it again!'
    else
      flash[:error] = 'Oops! Something went wrong! Please try again later!'
    end
    redirect_to root_path
  end

end