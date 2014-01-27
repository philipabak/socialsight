class MessageThreadsController < ApplicationController
  include MessageThreadsHelper
  ACCESSIBLE_STATUSES = %w{READ UNREAD}

  def index
    @message_threads = MessageThread.thread_for_user(current_user)
  end

  def new
    @message_thread = MessageThread.new
    @message = @message_thread.messages.build
    @message.receiver_id = params[:receiver_id]
    @message_thread.sender_id = current_user.id
    @message_thread.receiver_id = params[:receiver_id]
    @receiver_name = User.find(params[:receiver_id]).short_name
  end

  def create
    @message_thread = MessageThread.new(params[:message_thread])
    @message_thread.receiver_id = params[:message_thread][:messages_attributes]['0'][:receiver_id]
    @message_thread.sender_id = current_user.id
    if @message_thread.save
      # Get message to be send
      msg = @message_thread.messages.first
      # Send notification
      MessageMailer.new_message_mail(msg).deliver
      return redirect_to @message_thread
    end
    return redirect_to request.referer, alert: @message_thread.errors.full_messages.to_sentence
  end

  def show
    @message_thread = MessageThread.where('id = ? AND (sender_id = ? OR receiver_id = ?)', params[:id].to_s, current_user.id, current_user.id).first
    @message_thread.messages.where("status = 'UNREAD' AND receiver_id = ?", current_user).each { |x| x.update_attributes(:status => 'READ') }
    @message = @message_thread.messages.build
    @message.booking = Booking.new
    @receiver = @message_thread.opposite_member(current_user)
    @breadcrumbs = [{name: 'Messages',    link: message_threads_path},
                    {name: 'This Message',link: message_thread_path(@message_thread)}]
  end

  def delete_selected_threads
    if params[:ids]
      params[:ids].split(',').each do |id|
        current_user.sent_message_threads.where('id = ?', id).each do |thread|
          thread.update_attributes(:deleted_by_sender => 'true')
        end
        current_user.received_message_threads.where('id = ?', id).each do |thread|
          thread.update_attributes(:deleted_by_receiver => 'true')
        end
      end
    end
    render current_user.message_threads
  end

  def change_message_threads_status
    unless ACCESSIBLE_STATUSES.include? params[:status]
      return redirect_to message_threads_path, :notice => 'Something went wrong, please try again!'
    end
    params[:ids].split(',').each do |id|
      current_user.sent_message_threads.where('id = ?', id).each do |thread|
        thread.messages.reject { |x| x.receiver_id!=current_user.id }.each do |message|
          message.update_attributes(:status => params[:status])
        end
      end
      current_user.received_message_threads.where('id = ?', id).each do |thread|
        thread.messages.reject { |x| x.receiver_id!=current_user.id }.each do |message|
          message.update_attributes(:status => params[:status])
        end
      end
    end
    render current_user.message_threads
  end
end
