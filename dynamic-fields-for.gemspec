lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamic-fields-for/version'

Gem::Specification.new do |s|
  s.name        = 'dynamic-fields-for'
  s.version     = DynamicFieldsFor::VERSION.dup
  s.authors     = 'Sergey Tokarenko'
  s.email       = 'private.tokarenko.sergey@gmail.com'
  s.homepage    = 'https://github.com/stokarenko/dynamic-fields-for'
  s.summary     = 'Dynamic association fieldsets without pain.'
  s.description = s.summary
  s.license     = 'MIT'

  s.files       = Dir['{app}/**/*', '{lib}/**/*', 'LICENSE', 'README.md']

  s.add_dependency 'rails', '~> 4.1.8'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'association-soft-build'

  s.add_development_dependency 'bundler'
end
