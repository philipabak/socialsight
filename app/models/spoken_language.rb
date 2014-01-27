class SpokenLanguage < ActiveRecord::Base
  # relationships
  belongs_to :guide
  belongs_to :language
  belongs_to :language_level
  # security
  attr_accessible :guide_id, 
                  :language_id,
                  :language_level_id,
                  :as => [:default, :admin]
end