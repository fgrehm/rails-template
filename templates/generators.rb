Rails.application.config.generators do |g|
  g.stylesheets = false
  g.javascripts = false
  g.helper      = false

  g.test_framework = :rspec
  g.view_specs     = false
  g.routing_specs  = false
  g.request_specs  = false

  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
end
