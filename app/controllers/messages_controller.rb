# encoding: utf-8
class MessagesController < ApplicationController

  def create
    @message_thread = MessageThread.where('id = ? AND (sender_id = ? OR receiver_id = ?)', params[:message_thread_id].to_s, current_user.id, current_user.id).first

    # Check uploaded file size that less than 2 MB
    uploaded_io = params[:message][:attachment]
    if uploaded_io && calculate_file_size(uploaded_io)>=2
      return redirect_to @message_thread, :alert => "Can't upload files greater than 2MB!"
    end

    # Emails are based on current setup / Message after_create callback
    # TODO: Provide more solid implementation
    @message = Message.new(params[:message])
    @message.message_thread = @message_thread
    @message.receiver = @message_thread.receiver == current_user ? @message_thread.sender : @message_thread.receiver
    @message.sender = current_user
    @email = MessageMailer.new_message_mail(@message)

    if !params[:accept_booking] && !params[:need_booking] && (@message.message_text.empty? || @message.message_text.nil?)
      return redirect_to @message_thread, :alert => 'Message text is required!'
    end
    if params[:need_booking]
      @message.booking.user = @message.receiver
      @message.booking.guide = current_user.guide
      @email = BookingMailer.offer_alert_mail(@message)
    else
      @message.booking.delete if @message.booking
    end

    if @message_thread.has_active_booking?
      if params[:accept_booking]
        @message.modified_booking = @message_thread.active_booking
        @message_thread.active_booking.update_attributes(:status => 'ACCEPTED')
        accepted_id = @message_thread.accepted_booking.id
        Booking.includes(:message).where("messages.message_thread_id = ? AND bookings.status = 'OFFERED' OR (bookings.status = 'ACCEPTED' AND bookings.id != #{accepted_id})", @message_thread.id).each { |x| x.update_attributes(:status => 'REJECTED') }
        @email = BookingMailer.offer_accepted_mail(@message)
      end
    end

    if @message.save
      @email.deliver
      return redirect_to @message.message_thread
    end

    redirect_to @message_thread, :alert => 'Validation error for booking'
  end

  def attachment
    message = Message.where('id = ? AND (sender_id = ? OR receiver_id = ?)', params[:id].to_s, current_user.id, current_user.id).first
    return render :text => "You don't have permission to download this file!" unless message
    send_file message.attachment.path
  end

  private
  def calculate_file_size(uploaded_io)
    File.size(uploaded_io.tempfile)/1024/1024
  end
end
