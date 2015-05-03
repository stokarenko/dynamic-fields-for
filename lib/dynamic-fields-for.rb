require 'dynamic-fields-for/version'
require 'jquery-rails'
require 'association-soft-build'

module DynamicFieldsFor
  autoload :FormHelper, 'dynamic-fields-for/form_helper'
  autoload :SimpleFormHelper, 'dynamic-fields-for/simple_form_helper'
end

require 'dynamic-fields-for/railtie'
