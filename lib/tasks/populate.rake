require 'factory_girl'
 
namespace :db do
  desc "Populate the database with some sample data"
  task :populate, :guide_count, :comment_count do |t, args|
    args.with_defaults(guide_count: 80, comment_count: 300)
    puts "Populate with args: #{args}"

    puts "Resetting the database"
    Rake::Task['db:reset'].invoke

    puts "Creating Cities"
    FactoryGirl.create :city, name:"Debrecen"
    FactoryGirl.create :city, name:"Budapest"
    FactoryGirl.create :city, name:"London",         country_name:'UK'
    FactoryGirl.create :city, name:"New York",       country_name:'USA'
    FactoryGirl.create :city, name:"San Francisco",  country_name:'USA'
    FactoryGirl.create :city, name:"Peking",         country_name:'China'
    FactoryGirl.create :city, name:"Sydney",         country_name:'Australia'
    FactoryGirl.create :city, name:"Vienna",         country_name:'Austria'

    puts "Creating Guides: #{args.guide_count}"
    FactoryGirl.create_list :guide, args.guide_count.to_i

    puts "Creating Comments: #{args.comment_count}"
    FactoryGirl.create_list :comment, args.comment_count.to_i

    puts "Assign random values to guides and update avg_ratings"
    interests              = Interest.all
    services               = Service.all
    languages              = Language.all
    cities                 = City.all
    transportation_methods = TransportationMethod.all
    language_levels        = LanguageLevel.all
    rates = [0, 5, 10, 20, 99.9]

    Guide.all.each do |g|
      # Interests
      random_interest_count = Random.new.rand(2..interests.size)
      random_interest_array = (1..interests.size).to_a.sample(random_interest_count)
      g.interest_ids = random_interest_array

      # Rates
      random_service_count = Random.new.rand(2..services.size)
      random_service_array = (1..services.size).to_a.sample(random_service_count)
      g.service_ids = random_service_array

      # Languages
      random_language_count = Random.new.rand(2..4)
      random_language_array = (1..languages.size).to_a.sample(random_language_count)
      random_language_array.each do |l_id|
         SpokenLanguage.create language_id:       l_id,
                               guide_id:          g.id,
                               language_level_id: Random.new.rand(1..language_levels.size)
      end

      # Cities
      random_city_id = (1..cities.size).to_a.sample
      g.user.city_ids = random_city_id

      # Transportation Methods
      random_transportation_method_count = Random.new.rand(2..transportation_methods.size)
      random_transportation_method_array = (1..transportation_methods.size).to_a.sample(random_transportation_method_count)
      g.transportation_method_ids = random_transportation_method_array
      
      g.rate = rates.sample

      # Update avg rating of guide
      g.update_avg_rating
    end

    puts "Set guide completeness_scores"
    Guide.update_all(completeness_score: 100)

    puts "Done!"
  end
end