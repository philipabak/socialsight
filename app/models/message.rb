class Message < ActiveRecord::Base
  attr_accessible :message_thread_id, :message_thread, :sender, :receiver, :message_text, :status, :booking_attributes, :booking, :receiver_id, :sender_id, :created_at, :modified_booking, :attachment, :attachment_file_name
  belongs_to :message_thread
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  has_one :booking
  belongs_to :modified_booking, :class_name => 'Booking'
  accepts_nested_attributes_for :booking, :allow_destroy => true
  validates_presence_of :message_text, unless: :has_booking?

  has_attached_file :attachment, :path => ':rails_root/storage/message_attachments/:message_thread_id/:message_id_:basename.:extension'

  scope :unread_by_user_for_thread, lambda { |message_thread, user| where("message_thread_id = ? AND receiver_id = ? AND status = 'UNREAD'", message_thread, user) }
  scope :all_unread_by_user, lambda { |user| where("receiver_id = ? AND status = 'UNREAD'", user) }

  # Skip Message text validation if offer or accept
  def has_booking?
    booking.present? || modified_booking.present?
  end

  def has_attachment?
    !self.attachment_file_name.nil? && !self.attachment_file_name.empty?
  end
end
