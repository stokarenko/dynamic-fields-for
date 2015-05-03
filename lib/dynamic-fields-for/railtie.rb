require 'active_record/railtie'

module DynamicFieldsFor
  class Railtie < Rails::Engine

    initializer 'dynamic-fields-for.configure_rails_initialization' do
      ActiveSupport.on_load :action_view do
        ActionView::Helpers::FormBuilder.send :include, DynamicFieldsFor::FormHelper
      end
    end

  end
end
