class MessageThread < ActiveRecord::Base

  # relationships
  belongs_to :sender,   :class_name => :User
  belongs_to :receiver, :class_name => :User
  has_many :messages, order: 'created_at'
  has_many :bookings, :through => :messages

  # security 
  attr_accessible :sender_id, :receiver_id, :messages_attributes,
                  :deleted_by_sender, :deleted_by_receiver
  accepts_nested_attributes_for :messages, :allow_destroy => true                

  # scopes 
  scope :thread_for_user, lambda {|user| where('(receiver_id=? and deleted_by_receiver=false) or (sender_id=? and deleted_by_sender=false)', user.id, user.id).order('created_at DESC')}

  # Return with the opposite member of the conversation
  def opposite_member(user)
    user == sender ? receiver : sender
  end

  # Thread is open if we haven't got completed booking
  def is_open?
    bookings.completed.empty?
  end

  def completed_booking
    bookings.completed.last
  end

  def active_booking
    bookings.active.last
  end

  def has_active_booking?
    !active_booking.nil?
  end

  def accepted_booking
    bookings.accepted.last
  end

  def has_accepted_booking?
    !bookings.accepted.empty?
  end

  def self.unread_by_user(user)
    Message.count_by_sql("SELECT COUNT(DISTINCT message_thread_id) FROM messages WHERE status = 'UNREAD' AND receiver_id = #{user.id}")
  end

end
