Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins /localhost|134.209.255.104/
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options)
  end
end
