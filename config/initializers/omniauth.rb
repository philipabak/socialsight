OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Figaro.env.FB_APP_ID,
                      Figaro.env.FB_SECRET_KEY
end         