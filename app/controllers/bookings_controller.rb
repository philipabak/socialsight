class BookingsController < ApplicationController
  ACCESSIBLE_STATUSES = %w{COMPLETED}

  def index
    user_id  = current_user.id
    guide_id = current_user.guide.nil? ? -1 : current_user.guide.id
    @accepted_bookings = Booking.where("(user_id = ? OR guide_id = ?) AND bookings.status='ACCEPTED'", user_id, guide_id).order('created_at DESC')
    @completed_bookings = Booking.where("(user_id = ? OR guide_id = ?) AND bookings.status='COMPLETED'", user_id, guide_id).order('created_at DESC')
  end

  def change_booking_status
    unless ACCESSIBLE_STATUSES.include? params[:status]
      return redirect_to bookings_path, :notice => 'Something went wrong, please try again!'
    end

    user_id  = current_user.id
    guide_id = current_user.guide.nil? ? -1 : current_user.guide.id
    @booking = Booking.where('(user_id = ? OR guide_id = ?) AND bookings.id= ?', user_id, guide_id, params[:id].to_s).first
    old_status = @booking.status

    if @booking.update_attributes(:status => params[:status].to_s)
      BookingHistory.create(:old_status => old_status, :new_status => params[:status].to_s, :user_id => current_user.id, :date => Time.now, :booking_id => @booking.id)
      BookingMailer.booking_completed_mail(@booking.message).deliver
    end

    text = "Thank you, we hope you enjoyed the time you spend together! "+
           "Please help #{@booking.guide.user.short_name} with giving him/her a review - "+
           "how did you like the time spent together - it only takes a minute!"
    response = {text: text, go_url: "#{@booking.guide.link}#reviews", stay_url: bookings_path}
    respond_to {|format| format.js {render json: response}}
  end
end
