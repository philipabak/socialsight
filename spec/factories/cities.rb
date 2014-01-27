# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    name "Debrecen"
    country_name "Hungary"

    after(:build) { |city| city.geocode }
  end
end
