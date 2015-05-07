require 'dynamic-fields-for/version'
require 'jquery-rails'
require 'association-soft-build'

module DynamicFieldsFor
  autoload :FormHelper, 'dynamic-fields-for/form_helper'

  private

  def self.compile_assets
    file_src = File.expand_path('../../src/js.coffee', __FILE__)
    file_build = File.expand_path('../../app/assets/javascripts/dynamic-fields-for.js', __FILE__)
    File.write(file_build, CoffeeScript.compile(File.read(file_src)))
  end
end

require 'dynamic-fields-for/railtie'
