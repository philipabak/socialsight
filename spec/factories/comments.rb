# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
	  ignore do
			rand_rating {Random.new.rand(1..10)}
	  end

    body        { Faker::Lorem.paragraphs 2}
    rating      { rand_rating>3 ? 1 : -1 }
    commentable { Guide.offset(rand(Guide.count)).first}
    user        { User.offset(rand(User.count)).first}
  end
end