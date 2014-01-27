ActiveAdmin.register MessageThread do
  index do
    column :id
    column :sender
    column :deleted_by_sender
    column :receiver
    column :deleted_by_receiver
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :sender      
      row :deleted_by_sender
      row :receiver
      row :deleted_by_receiver
      row :created_at
      row :updated_at
    end

    panel 'Messages' do
      table_for message_thread.messages.order('id') do
        column :id
        column :message_text
        column :status
        column :created_at
      end
    end
  end    

  actions :index, :show
end
