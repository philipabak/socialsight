class TransportationMethod < ActiveRecord::Base
  # relationships
  has_and_belongs_to_many :guides

  # security 
  attr_accessible :name

  # validations
  validates :name, :presence => true,
            :uniqueness => { :case_sensitive => false }
end
