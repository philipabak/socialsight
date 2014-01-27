# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    sequence(:name)           {|n| "Service #{n}" }
    sequence(:icon_css_class) {|n| "Css Class #{n}" }
    sequence(:description)    {|n| "Description #{n}" }
  end
end
