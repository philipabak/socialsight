# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  male_pics =   ['m_01.jpg','m_02.jpg','m_03.jpg','m_04.jpg',
                 'm_05.jpg','m_06.png','m_07.png']
  female_pics = ['f_01.jpg','f_02.jpg','f_03.jpg','f_04.jpg',
                 'f_05.jpg','f_06.png','f_07.png']             

  factory :user do
    sequence(:email) {|n| "user#{n}@sss.com" }
    password "almafa"
    password_confirmation "almafa"
    is_admin true
    first_name          { Faker::Name.first_name }
    last_name           { Faker::Name.last_name}
    birth_date          { Time.at(Random.new.rand(55.year.ago.to_i..18.year.ago.to_i))}
    sex                 { User::GENDERS[0..-1].sample}
    avatar { File.open(Rails.root.join('app', 'assets', 'images',
                       sex=="Male" ? male_pics.sample : female_pics.sample)) }
  end
end