module MessageThreadsHelper
  # TODO refactoring
  # Can offer if:
  def can_offer?
    return false unless @message_thread.is_open?
    # has receiver and current user is a guide and thread is open and hasn't got active booking
    ((@receiver && current_user.is_guide? && @message_thread.is_open? && (!@message_thread.has_active_booking? && !@message_thread.has_accepted_booking?)) ||
        # thread is open and has active booking from the current user
        (@message_thread.is_open? && @message_thread.has_active_booking? && @message_thread.active_booking.guide.user == current_user) ||
        # or thread has accepted offer from current user
        (@message_thread.has_accepted_booking? && @message_thread.bookings.accepted.last.guide.user == current_user)
    )
  end

end
