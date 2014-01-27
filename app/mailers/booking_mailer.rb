class BookingMailer < ActionMailer::Base
  include Sidekiq::Mailer
  sidekiq_options retry: 'false'
  default from: "info@socialsightseeing.com"

  def offer_alert_mail(message)
    @sender    = message.sender
    @receiver  = message.receiver
    @link      = message_thread_url(message.message_thread)

    mail to: @receiver.email,
         subject: "=?UTF-8?B?4oaS?= You got a new offer from #{@sender.short_name}!"
  end 

  def offer_accepted_mail(message)
    @sender    = message.sender
    @receiver  = message.receiver
    @link      = message_thread_url(message.message_thread)

    mail to: @receiver.email,
         subject: "=?UTF-8?B?4oaS?= Your offer has been accepted by #{@sender.short_name}!"
  end

  def booking_completed_mail(message)
    host = Rails.application.config.action_mailer.default_url_options[:host]

    @sender    = message.sender
    @receiver  = message.receiver
    @link      = "#{host}/#{@sender.guide.slug}#reviews"

    mail to: @receiver.email,
         subject: "=?UTF-8?B?4oaS?= Your booking has been completed by #{@sender.short_name}!"
  end  
end
