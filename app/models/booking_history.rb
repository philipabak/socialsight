class BookingHistory < ActiveRecord::Base
  attr_accessible :booking, :user, :old_status, :new_status, :date, :user_id, :booking_id
  belongs_to :booking
  belongs_to :user
end
