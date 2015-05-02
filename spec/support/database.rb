ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.include_root_in_json = true

ActiveRecord::Migrator.migrate(File.expand_path('../../rails_app/db/migrate/', __FILE__))

RSpec.configure do |config|
  config.fixture_path = File.expand_path('../../fixtures', __FILE__)
  config.use_transactional_fixtures = true
  config.global_fixtures = :all
end
