class GuideImage < ActiveRecord::Base
  # relationships
  belongs_to :guide
  has_attached_file :image, :styles => {thumb_mini: "58x58#",
                                        thumb:      "100x100#"},
                    :default_url => 'missing_:style.png'
  # security 
  attr_accessible :guide_id, :image
end
