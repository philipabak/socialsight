class CreateGuidesInterestsTable < ActiveRecord::Migration
  def up
    create_table :guides_interests, :id => false do |t|
      t.references :guide
      t.references :interest
    end
    add_index :guides_interests, [:guide_id, :interest_id]
  end

  def down
    drop_table :guides_interests
  end
end
