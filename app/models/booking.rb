class Booking < ActiveRecord::Base
  attr_accessible :message, :user, :guide, :price, :status, :updated_at, :created_at
  # relationships
  belongs_to :user
  belongs_to :guide
  belongs_to :message
  has_many :booking_histories
  validates :price, :numericality => {:greater_than => 0, :only_integer => true}

  # scopes
  scope :active, where("bookings.status = 'OFFERED'")
  scope :rejected, where("bookings.status = 'REJECTED'")
  scope :accepted, where("bookings.status = 'ACCEPTED'")
  scope :completed, where("bookings.status = 'COMPLETED'")

  def self.completed_between? (user, guide)
    Booking.completed.where("user_id=? and guide_id=?", user.id, guide.id).size>0
  end

  def is_rejected?
    status == "REJECTED"
  end

  def is_completed?
    status == "COMPLETED"
  end
end
