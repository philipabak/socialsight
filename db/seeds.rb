puts "Creating Languages"
Language.create name: 'English'
Language.create name: 'German'
Language.create name: 'French'
Language.create name: 'Spanish'
Language.create name: 'Italian'
Language.create name: 'Dutch'

puts "Creating Languages Levels"
LanguageLevel.create name: 'Basic'
LanguageLevel.create name: 'Intermediate'
LanguageLevel.create name: 'Advanced'
LanguageLevel.create name: 'Fluent'
LanguageLevel.create name: 'Native'

puts "Creating Interests"
Interest.create name: 'Sports'
Interest.create name: 'Arts & History'
Interest.create name: 'Nightlife'
Interest.create name: 'Collecting'
Interest.create name: 'Food & wine'
Interest.create name: 'Strip bars'
Interest.create name: 'Tourist attractions'

puts "Creating Services"
Service.create name: 'Sporty sightseeing',
               description: 'Stay fit and have fun - go running or cycling with your local guide, or do any other sporty activiity together, and discover the city meanwhile!',
               icon_css_class: 'icon_sporty'
Service.create name: 'Coffee sightseeing',
               description: 'Have a coffee (or a drink) with a local, and let him/her tell you about the place, the customs, what to see, where to eat, how much things should costs, what is safe and what is not, etc.',
               icon_css_class: 'icon_coffee'
Service.create name: 'Social sightseeing',
               description: 'Gddo sightseeing together with your favourite local, and let him/her show you, why is it good place to live (no, not because of the tourist attractions). Forget the museums, and have real fun!',
               icon_css_class: 'icon_social'
Service.create name: 'Online sightseeing',
               description: 'Let a local help you make your perfect, unique travel plan. Just tell them your interest and preferences, and let them make your stay perfect.',
               icon_css_class: 'icon_online'

puts "Creating Transportation Methods"
TransportationMethod.create name: 'Walking'
TransportationMethod.create name: 'Bicycle'
TransportationMethod.create name: 'Public transport'
TransportationMethod.create name: 'Own car'