class Service < ActiveRecord::Base
  # relationships
  has_many :rates
  has_many :guides, through: :rates

  # security
  attr_accessible :name, :description, :icon_css_class
end
