require 'active_record/railtie'

module DynamicFieldsFor
  class Engine < Rails::Engine

    initializer 'dynamic-fields-for.configure_rails_initialization' do
      require 'dynamic-fields-for/feature'
    end
  end
end
