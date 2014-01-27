class LocationSearchDetail < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :location_search
  # security 
  attr_accessible :ip, :location_search, :user
end
