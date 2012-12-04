if ENV['COVERAGE']
  require './spec/simplecov_setup'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

require 'mail'
require 'capybara-email'
require 'capybara/email/rspec'

require 'database_cleaner'
require 'rspec-spies'
require 'forgery'
require 'shoulda-matchers'
require 'rspec-spies'
require 'factory_girl_rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Capybara::DSL,         :example_group => { :file_path => /\bspec\/acceptance\// }
  # config.include Warden::Test::Helpers, :example_group => { :file_path => /\bspec\/acceptance\// }

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(type: :request) do
    DatabaseCleaner.strategy = :truncation
    # Warden.test_mode!
    # clear_emails
  end

  config.after(type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
