# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do 
  factory :guide do
    is_professional     false
    short_introduction  { Faker::Lorem.sentences 2}
    long_introduction   { Faker::Lorem.paragraphs 2}
    user
  end
end
