class Language < ActiveRecord::Base
  # relationships
  has_many :spoken_languages
  has_many :guides, through: :spoken_languages

  # security
  attr_accessible :name

  # Returns languages in a format that can be used for dropdown with optgroup 
  def self.priority_list(*priority_language_list)
    languages_by_name = Language.order(:name)
    priority_countries = languages_by_name.select{|language| priority_language_list.include?(language.name)}
    
    languages_by_name_array = languages_by_name.map{|l| [l.name, l.id]}
    priority_countries_array = priority_countries.map{|l| [l.name, l.id]}
    [['Popular Languages', priority_countries_array], ['Other Languages',languages_by_name_array]]
  end
end
