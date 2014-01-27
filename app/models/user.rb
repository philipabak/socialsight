class User < ActiveRecord::Base
  # relationships
  belongs_to :guide, dependent: :destroy
  has_and_belongs_to_many :cities, join_table: "users_cities",
                          after_add: :update_cities_counter_cache,
                          after_remove: :update_cities_counter_cache

  has_many :sent_message_threads, class_name: "MessageThread",
            foreign_key: :sender_id, conditions: "deleted_by_sender = 'false'"
  has_many :received_message_threads, class_name: "MessageThread",
            foreign_key: :receiver_id, conditions: "deleted_by_receiver = 'false'"

  # security 
  attr_accessible :birth_date, :first_name, :last_name, :sex,
                  :email, :password, :password_confirmation, :avatar, :city_ids,
                  :as => [:default, :admin]
  attr_accessible :is_admin, :as => [:admin]

  # validations
  validates :email, presence:   true,
                    uniqueness: {:case_sensitive => false}

  validates :password, presence: true,
                       confirmation: true,
                       length: {:within => 6..40},
                       on: :create
  validates :password, confirmation: true,
                       length: {:within => 6..40},
                       allow_blank: true,
                       on: :update

  # callbacks
  after_create :send_registration_mail
  after_create :add_to_mailchimp, if: Proc.new{Rails.env.production?}

  # scopes
  scope :not_guides,   where(guide_id: nil)
  scope :guides,       where("guide_id IS NOT NULL")
  scope :male,         where(sex:"Male")
  scope :female,       where(sex:"Female")
  scope :age_between,  lambda{|from, to| where(birth_date: (to.to_i + 1).years.ago..from.to_i.years.ago) }

  # arrays
  GENDERS = ["Male", "Female"]

  # config
  has_secure_password
  has_attached_file :avatar, styles: {thumb_mini: "58x58#",
                                      thumb:      "100x100#",
                                      medium:     "220x220#",
                                      large:      "330x330#"},
                    :default_url => 'missing_:style.png'
  # paperclip callback
  before_post_process :check_and_correct_file_extension

  def self.from_omniauth(auth)
    where('oauth_provider = ? and oauth_uid = ?',
      auth[:provider], auth[:uid]).first_or_initialize.tap do |user|
      user.email            = auth.info.email
      user.first_name       = auth.info.first_name
      user.last_name        = auth.info.last_name
      user.sex              = "Male"   if auth.extra.raw_info.gender == "male"
      user.sex              = "Female" if auth.extra.raw_info.gender == "female"
      user.birth_date       = Date.strptime auth.extra.raw_info.birthday, '%m/%d/%Y' unless auth.extra.raw_info.birthday.nil?
      user.oauth_provider   = auth.provider
      user.oauth_uid        = auth.uid
      user.oauth_name       = auth.info.name
      user.oauth_token      = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      #Fetch City
      if user.cities.blank?
        raw_info = auth.extra.raw_info
        # Current location
        if raw_info.location.present? && raw_info.location.name.present?
          city = City.cityname_to_city(auth.extra.raw_info.location.name)
        elsif raw_info.hometown.present? && raw_info.hometown.name.present?
          city = City.cityname_to_city(auth.extra.raw_info.hometown.name)
        end
        user.cities = [city] if city.present?
      end
      #Fetch fb image if user does not have avatar yet
      if user.avatar.blank? && auth.info.image.present?
        user.avatar = fetch_fb_profile_image(auth.info.image)
      end    
      #random password, that won't be used, for first users
      user.password = ::SecureRandom.hex(16) unless user.password_digest?
      # Fetch FB friend count
      graph = Koala::Facebook::API.new(auth.credentials.token)
      user.fb_friend_count = graph.get_connections("me", "friends").count

      user.save!
    end
  end

  def is_admin?
    self.is_admin == true
  end

  def is_guide?
    self.guide_id != nil
  end

  def is_fb_verified?
    self.oauth_provider == 'facebook' && self.fb_friend_count >=100
  end

  def attach_new_guide
    if not is_guide?
      # Default Language
      sl = SpokenLanguage.new
      sl.language = Language.where(name: 'English').first
      sl.language_level = LanguageLevel.where(name: 'Intermediate').first
      # Guide
      guide = Guide.new
      guide.spoken_languages = [sl]
      guide.user = self
      guide.save!
    end
  end

  def username
    if first_name.blank? or last_name.blank?
      email
    else
      "#{first_name}, #{last_name}"
    end
  end

  def age
    now = Time.now.utc.to_date

    if birth_date.present?
      now.year - birth_date.year - (birth_date.to_date.change(year: now.year) > now ? 1 : 0)
    else
      ""
    end         
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    "#{first_name} #{last_name[0]}." rescue username
  end

  def message_threads
    sent_message_threads + received_message_threads
  end

  def send_password_reset
    self.password_reset_token = ::SecureRandom.hex(16)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private
  # Fixes FB fetching without extensions bug
  def check_and_correct_file_extension
    extension = File.extname(avatar_file_name).downcase
    self.avatar.instance_write(:file_name, "#{avatar_file_name}.jpg") if extension.blank?
  end

  def send_registration_mail
    UserMailer.registration_mail(self).deliver
  end

  def add_to_mailchimp
    mailchimp = MailchimpService.new
    mailchimp.subscribe_user_to_list(self)
  rescue Gibbon::MailChimpError => ex
    logger.error(ex)
  end

  def self.fetch_fb_profile_image(url)
    adjusted_url = adjust_fb_image_url_with_size(url, 300, 300)
    open(adjusted_url)
  end

  def self.adjust_fb_image_url_with_size(url, width, height)
    url_without_params = url.split('?')[0]
    "#{url_without_params}?width=#{width}&height=#{width}"
  end

  def update_cities_counter_cache(city)
    city.update_guide_cache
  end

end