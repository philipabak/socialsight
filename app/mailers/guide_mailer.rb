class GuideMailer < ActionMailer::Base
  include Sidekiq::Mailer
  sidekiq_options retry: 'false'
  default from: "info@socialsightseeing.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.guide_mailer.profile_complete_mail.subject
  #
  def profile_complete_mail(guide)
    mail to: guide.user.email,
         subject: "=?UTF-8?B?4oaS?= You are successfully registered as a guide"
  end
end
