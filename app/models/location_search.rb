class LocationSearch < ActiveRecord::Base
  # relationships
  has_many :location_search_detail
  # security 
  attr_accessible :query, :search_count

  def self.create_with_detail(query, user, ip)
    ls = LocationSearch.find_or_create_by_query query: query
    lsd = LocationSearchDetail.create user:            user,
                                      ip:              ip,
                                      location_search: ls
    ls.search_count = LocationSearchDetail.where(location_search_id: ls).count
    ls.save                                      
  end
end
