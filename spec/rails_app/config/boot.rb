module DynamicFieldsFor
  def self.rails3?
    rails_version == 3
  end

  def self.rails_version
    Rails.version[0].to_i
  end
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
