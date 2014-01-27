class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :friendly_link, use: :slugged
  geocoded_by :formatted_with_country

  # relationships
  has_and_belongs_to_many :users, join_table: "users_cities"

  # security 
  attr_accessible :country_name, :longitude, :latitude, :name

  # validations
  validates_presence_of :name
  validates_presence_of :country_name
  validates_presence_of :longitude
  validates_presence_of :latitude

  # scopes
  scope :closest_cities, lambda { |query, limit=9| City.near(query, 500000, order: 'distance').limit(limit)}
  #Cities with the most guides
  scope :top, lambda { |limit| City.order('guides_count desc').limit(limit)}
  scope :top5, top(5)
     
  def self.cityname_to_city(cityname)
    city_hash = Geocoder.search(cityname)
    ac        = city_hash[0].address_components

    country_name = nil
    # Find country name in geocoder response
    ac.each{|ac| country_name = ac['long_name'] if ac['types'][0]=='country' }
    city_candidate = City.new(
            name:         ac[0]['long_name'],
            country_name: country_name,
            latitude:     city_hash[0].geometry['location']['lat'],
            longitude:    city_hash[0].geometry['location']['lng']
    )
    # Find existing city in 1 mile radius
    existing_city = City.near(city_candidate, 1)
    existing_city.present? ? existing_city.first : city_candidate
  end

  def self.update_guide_cache_for_cities(cities)
    cities.each { |city| city.update_guide_cache }
  end

  def update_guide_cache
    count = User.includes(:cities).where('users_cities.city_id=? and users.guide_id IS NOT NULL', self.id).size
    self.guides_count = count
    self.save!
  end

  def featured_guide
    Guide.joins(user: :cities)
          .where('city_id = ?', self.id)
          .where('completeness_score=100')
          .order('positive_review_count DESC').limit(1).first   
  end

  def formatted_with_country
    "#{name}, #{country_name}"
  end

  def friendly_link
    "#{name}-guides"
  end

  def to_s
    formatted_with_country
  end
end