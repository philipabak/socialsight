# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language_level do
    sequence(:name) {|n| "LanguageLevel #{n}" }
  end
end
