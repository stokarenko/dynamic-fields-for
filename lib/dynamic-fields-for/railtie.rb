require 'active_record/railtie'

module DynamicFieldsFor
  class Engine < Rails::Engine

    initializer 'dynamic-fields-for.configure_rails_initialization' do
      ActiveSupport.on_load :action_view do
        ActionView::Helpers::FormBuilder.send :include, DynamicFieldsFor::FormHelper

        begin
          # Check is simple_form available
          require 'simple_form'
          ActionView::Helpers::FormBuilder.send :include, DynamicFieldsFor::SimpleFormHelper
        rescue LoadError
        end

      end
    end
  end
end
