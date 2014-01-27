class Rate < ActiveRecord::Base
  # relationships
  belongs_to :guide
  belongs_to :service
  # security
  attr_accessible :guide_id, :rate, :service_id
end
