# config/initializers/sidekiq_mailer.rb
Sidekiq::Mailer.excluded_environments = [:development, :test, :cucumber, :staging, :production]

#For testing locally also
#Sidekiq::Mailer.excluded_environments = [:test, :cucumber]