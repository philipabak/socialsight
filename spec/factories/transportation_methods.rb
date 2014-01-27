# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transportation_method do
    sequence(:name) {|n| "Transportation Method #{n}" }
  end
end
