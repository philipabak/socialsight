class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date :birth_date
      t.string :sex
      t.text :short_introduction
      t.text :long_introduction

      t.timestamps
    end
  end
end
