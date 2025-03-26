source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.tool-versions'
gem 'rails', '8.0.2'

# global
# gem install bundler
# gem install foreman
# gem install debug

gem 'awesome_print', '1.9.2'
gem 'blazer', '3.2.1'
gem 'bootsnap', '1.18.4', require: false
gem 'caxlsx', '4.2.0'
gem 'caxlsx_rails', '0.6.4'
gem 'cssbundling-rails', '1.4.3'
gem 'csv', '3.3.3'
gem 'devise', '4.9.4'
gem 'faker', '3.5.1'
gem 'good_job', '4.9.3'
gem 'jbuilder', '2.13.0'
gem 'jsbundling-rails', '1.3.1'
gem 'maintenance_tasks', '2.11.0'
gem 'pagy', '9.3.4'
gem 'pg', '1.5.9'
gem 'pghero', '3.6.2'
gem 'pretender', '0.5.0'
gem 'propshaft', '1.1.0'
gem 'puma', '6.6.0'
gem 'pundit', '2.5.0'
gem 'ransack', '4.3.0'
gem 'roo', '2.10.1'
gem 'simple_form', '5.3.1'
gem 'stimulus-rails', '1.3.4'
gem 'thruster', '0.1.12', require: false
gem 'turbo-rails', '2.0.13'
gem 'tzinfo-data', '1.2025.2'
gem 'view_component', '3.22.0'

group :production, :staging do
  gem 'honeybadger', '5.27.1'
end

group :development, :test do
  gem 'debug', '1.10.0'
  gem 'factory_bot_rails', '6.4.4'
  gem 'rspec-rails', '7.1.1'
end

group :development do
  gem 'brakeman', '7.0.0', require: false
  gem 'bullet', '8.0.1'
  gem 'bundler-audit', '0.9.2', require: false
  gem 'lookbook', '2.3.8'
  gem 'rubocop', '1.74.0', require: false
  gem 'web-console', '4.2.1'
end

group :test do
  gem 'capybara', '3.40.0'
  gem 'database_cleaner-active_record', '2.2.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-github', '3.0.0', require: false
  gem 'rspec-instafail', '1.0.0', require: false
  gem 'rspec-json_expectations', '2.2.0'
  gem 'rspec_junit_formatter', '0.6.0'
  gem 'rspec-longrun', '3.1.0'
  gem 'selenium-webdriver', '4.30.1'
  gem 'shoulda-matchers', '6.4.0'
  gem 'timecop', '0.9.10'
  gem 'vcr', '6.3.1'
  gem 'webmock', '3.25.1'
end
