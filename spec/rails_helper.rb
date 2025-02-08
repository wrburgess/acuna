require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production or staging
abort('The Rails environment is running in production mode!') if Rails.env.production? || Rails.env.staging?
require 'capybara/rspec'
require 'pundit/rspec'
require 'rake'
require 'rspec/rails'
require 'shoulda/matchers'
include RSpec::Longrun::DSL

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Capybara.register_driver :selenium_with_long_timeout do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 90
  Capybara::Selenium::Driver.new(app, browser: :chrome, http_client: client)
end

RSpec.configure do |config|
  config.extend ControllerMacros, type: :component
  config.extend ControllerMacros, type: :controller
  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Capybara::RSpecMatchers, type: :component
  config.include Devise::Test::ControllerHelpers, type: :component
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include TomSelectHelper, type: :feature
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include ViewComponent::TestHelpers, type: :component
  config.include Warden::Test::Helpers

  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.use_transactional_fixtures = true

  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.after(:each) do
    Warden.test_reset!
  end

  config.before(:each, type: :component) do
    @request = vc_test_controller.request
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    unless example.metadata[:skip_db_cleaner]
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end

  # TODO: Remove below adjustments when Devise fixes https://github.com/heartcombo/devise/issues/5705
  config.before(:each, type: :controller) do
    Rails.application.reload_routes_unless_loaded
  end

  config.before(:each, type: :component) do
    Rails.application.reload_routes_unless_loaded
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

DatabaseCleaner.allow_remote_database_url = true
