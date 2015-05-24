require 'active_record/railtie'

module DynamicFieldsFor
  class Engine < Rails::Engine

    initializer 'dynamic-fields-for.configure_rails_initialization' do
      ActiveSupport.on_load :action_view do
        RubyFeatures.apply 'activerecord_devkit/association_soft_build'
        ActionView::Helpers::FormBuilder.send :include, DynamicFieldsFor::FormHelper
      end
    end
  end
end
