ActiveAdmin.register Booking do
  controller do
    def scoped_collection
      Booking.includes(:message)
    end
  end

  filter :status, as: :check_boxes,
                  collection: {offered:   'OFFERED',
                               rejected:  'REJECTED',
                               accepted:  'ACCEPTED',
                               completed: 'COMPLETED'},
                  include_blank: false
  filter :id,       label:'Booking Number'                 
  filter :message_message_text, label: 'Booking message', as: :string
  filter :price
  filter :user_id,  label:'USER ID', as: :numeric
  filter :guide_id, label:'GUIDE ID', as: :numeric

  index do
    column :id
    column :status
    column :price
    column :user
    column :guide
    column :updated_at
    column 'Message'       do |booking| booking.message.message_text end
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :status      
      row :price
      row :user
      row :guide
      row :created_at
      row 'Message'       do booking.message.message_text end
      row 'MessageThread' do booking.message.message_thread end
    end

    panel 'History' do
      table_for booking.booking_histories do
        column :id
        column :user
        column :old_status
        column :new_status
        column :date
      end
    end
  end  

  actions :index, :show
end