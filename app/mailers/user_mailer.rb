class UserMailer < ActionMailer::Base
  include Sidekiq::Mailer
  sidekiq_options retry: 'false'
  default from: "info@socialsightseeing.com"

  def registration_mail(user)
    mail to: user.email,
         subject: "=?UTF-8?B?4oaS?= Welcome to the Social Sightseeing community"
  end

  def password_reset(user)
    @link = edit_password_reset_url(user.password_reset_token)
    @user = user
    mail to: user.email,
         subject: "=?UTF-8?B?4oaS?= Password reset"
  end
end
