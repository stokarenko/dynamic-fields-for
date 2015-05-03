ENV['RAILS_ENV'] ||= 'test'
require 'rails_app/config/environment'
require 'rspec/rails'
require 'capybara/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  Capybara.default_driver = :webkit
end
