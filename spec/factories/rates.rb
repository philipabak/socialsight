# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rate do
    guide_id 1
    service_id 1
    rate 1.5
  end
end
