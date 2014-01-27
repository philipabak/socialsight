SocialSightseeing::Application.routes.draw do
  ActiveAdmin.routes(self)
  root :to => "home#index"
  resource :user
  resource :guide
  resources :password_resets
  resources :sessions

  resources :guides do
    resources :comments do
      get 'editcomment_template', to: 'comments#editcomment_template'
    end
  end  

  get 'signup', to: 'users#new', as: 'signup'
  get 'login',  to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  #For omniauth
  match 'auth/:provider/callback', to: 'sessions#create_fb'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  match 'message_threads/delete_selected_threads', to: "message_threads#delete_selected_threads", as: 'delete_selected_threads'
  match 'message_threads/change_message_threads_status', to: "message_threads#change_message_threads_status", as: 'change_message_threads_status'
  match 'message_threads/:message_thread_id/messages/:id/attachment' => "messages#attachment", :as => :message_attachment
  resources :message_threads do
    resources :messages
  end

  resources :bookings
  match 'bookings/:id/change_booking_status', to: "bookings#change_booking_status", as: 'change_booking_status'

  post 'newsletter_signup', to: 'newsletter#signup', as: 'newsletter_signup'

  # Static sites for Pages controller
  match 'how-it-works',   to: 'pages#how_it_works', as: 'how_it_works'
  match 'guide-registration-thankyou', to: 'pages#guide_registration_thankyou', as: 'guide_registration_thankyou'
  match 'how-to-set-up-your-guide-profile', to: 'pages#how_to_set_up_your_guide_profile', as: 'how_to_set_up_your_guide_profile'
  match 'terms-of-use', to: 'pages#terms_of_use', as: 'terms_of_use'
  match 'privacy-policy', to: 'pages#privacy_policy', as: 'privacy_policy'
  match 'why-join-as-a-guide', to: 'pages#why_join_as_a_guide', as: 'why_join_as_a_guide'
  match 'why-join-as-a-professional-guide', to: 'pages#why_join_as_a_professional_guide', as: 'why_join_as_a_professional_guide'
  #Custom City routes
  match 'city_search',    to: 'cities#city_search', as: 'city_search'
  match 'city_not_found', to: 'cities#not_found', as: 'city_not_found'
  match ':cityname',      to: "cities#show", cityname: /[a-zA-Z].*-guides/
  # Capture all request and try to find guide
  match ':guidename',     to: "guides#show"
end
