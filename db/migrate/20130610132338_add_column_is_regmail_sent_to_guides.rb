class AddColumnIsRegmailSentToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :is_regmail_sent, :boolean, default: false, null: false
  end
end
