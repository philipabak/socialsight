class MessageMailer < ActionMailer::Base
  include Sidekiq::Mailer
  sidekiq_options retry: 'false'
  default from: "info@socialsightseeing.com"

  def new_message_mail(message)
    @sender    = message.sender
    @receiver  = message.receiver
    @link      = message_thread_url(message.message_thread)

    mail to: @receiver.email,
         subject: "=?UTF-8?B?4oaS?= You got new message from #{@sender.short_name}"
  end   
end
