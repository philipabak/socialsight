class Guide < ActiveRecord::Base
  extend FriendlyId
  friendly_id :friendly_link, use: :slugged
  acts_as_commentable
  delegate :cities, to: :user

  # relationships
  has_one :user, dependent: :destroy
  has_and_belongs_to_many :interests, order: 'name'
  has_and_belongs_to_many :transportation_methods, order: 'name'

  has_many :spoken_languages
  has_many :languages, through: :spoken_languages  

  has_many :rates
  has_many :services, through: :rates

  has_many :guide_images, dependent: :destroy

  # security 
  attr_accessible :long_introduction, :short_introduction,
                  :rate, :is_professional, :is_phone_verified,
                  :user_attributes,
                  :language_ids,
                  :service_ids,
                  :interest_ids,
                  :transportation_method_ids,
                  :rate_ids, :rates_attributes,
                  :spoken_language_ids, :spoken_languages_attributes,
                  :guide_images, :guide_images_attributes,
                  :as => [:default, :admin]

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :rates,            allow_destroy: true
  accepts_nested_attributes_for :spoken_languages, allow_destroy: true
  accepts_nested_attributes_for :guide_images,     allow_destroy: true

  # validations
  validates_presence_of :user
  validates_length_of :short_introduction, :maximum => 200

  # callbacks
  after_commit :update_completeness_score

  # scopes 
  scope :can_guide,       where(completeness_score: 100)
  scope :has_pos_review,  lambda { |num=1| where('positive_review_count >=?', num)}

  # arrays
  SORT_BY = ["", "Rating", "Age"]
  AGE_GROUPS = ["", "0-20", "21-30", "31-40", "40-99"]

  def self.get_random_guides_with_pos_review(num = 8)
    # Fetch ids and randomize with sample
    ids = Guide.select(:id).can_guide.has_pos_review.sample(num).map{|g| g.id}
    # Load guide, cities complete
    Guide.includes(user: :cities).where('id IN (?)', ids)
  end

  def transport_methods_with_commas
    transportation_methods.map{ |tm| "#{tm.name}" }.join(', ')
  end

  def spoken_languages_with_levels
    spoken_languages_array.join(', ')
  end

  def interests_with_commas
    interests.map{|i| i.name}.join(', ')
  end

  def spoken_languages_array
    spoken_languages.map{ |sl| "#{sl.language.name}(#{sl.language_level.name})" }
  end

  def set_city_via_params(params)
    #If city params are valid, update city
    if params[:city].present? &&
       params[:city][:name].present? &&
       params[:city][:country_name].present?
      city = City.find_or_initialize_by_name_and_country_name(params[:city])
      self.user.cities = [city]
    end
  end

  def add_spoken_language (language, level)
    lang       = Language.select(:id).where(name: language).first
    lang_level = LanguageLevel.select(:id).where(name: level).first

    if lang.present? && lang_level.present?
     sl = SpokenLanguage.new  language_id:       lang.id,
                              language_level_id: lang_level.id
     self.spoken_languages << sl
    else
      logger.warn "Guide could not set set_spoken_language for guide #{self.id}, "\
                  "lang: #{language}, level:#{level}"
    end
  end

  def update_avg_rating
    if comment_threads.count > 0
      self.positive_review_count = comment_threads.where("rating=1" ).count(:rating)
      self.negative_review_count = comment_threads.where("rating=-1").count(:rating)
      self.positive_review_proportion = (self.positive_review_count.to_f /
                                        (self.positive_review_count +
                                          self.negative_review_count))* 100
    else
      self.positive_review_count = 0
      self.negative_review_count = 0
      self.positive_review_proportion = 0
    end
    save
  end

  def can_be_rated_by?(user)
    self.id != user.guide_id &&                       # User should not rate (him/her)self
    Booking.completed_between?(user, self) &&         # User and Guide should have completed booking
    Comment.comments_on_guide_by(self, user).size < 1 # User can have only 1 rating for a guide
  end

  def review_count
    positive_review_count + negative_review_count
  end

  def has_review?
    positive_review_count > 0 || negative_review_count > 0
  end
  
  def update_completeness_score
    self.completeness_score = compute_completeness_score
  end

  def link
    "/#{self.slug}"
  end

  def friendly_link
    "#{self.user.first_name}-#{self.user.last_name}"
  end

  def to_s
    "(#{self.id})-#{self.user.last_name},#{self.user.first_name}"
  end

  private
    def compute_completeness_score
      score = 0
      score += 25 if self.user.avatar?
      score += 15 if self.cities.present?
      score += 10 if self.short_introduction.present?
      score += 10 if self.spoken_languages.present?
      score += 10 if self.rate.present?
      score += 10 if self.rates.present?
      score += 10 if self.transportation_methods.present?
      score += 10 if self.interests.present?
      score
    end
end
