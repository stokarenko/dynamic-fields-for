module DynamicFieldsFor
  def self.compile_assets
    file_src = File.expand_path('../../../src/js.coffee', __FILE__)
    file_build = File.expand_path('../../../app/assets/javascripts/dynamic-fields-for.js', __FILE__)
    File.write(file_build, CoffeeScript.compile(File.read(file_src)))
  end
end

RSpec.configure do |config|
  config.before(:all){ DynamicFieldsFor.compile_assets }
end
