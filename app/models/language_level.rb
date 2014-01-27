class LanguageLevel < ActiveRecord::Base
  # relationships
  has_many :spoken_languages
  # security
  attr_accessible :name
end
