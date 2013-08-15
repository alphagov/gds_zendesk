# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gds_zendesk/version'

Gem::Specification.new do |gem|
  gem.name          = "gds_zendesk"
  gem.version       = GDSZendesk::VERSION
  gem.authors       = ["Jake Benilov"]
  gem.email         = ["benilov@gmail.com"]
  gem.description   = %q{Client and models for communicating with Zendesk}
  gem.summary       = %q{Client and models for communicating with Zendesk}
  gem.homepage      = "https://github.com/alphagov/gds_zendesk"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'null_logger', '0.0.1'
  gem.add_dependency 'zendesk_api', '0.4.0.rc1'

  gem.add_development_dependency 'rake', '10.0.3'
  gem.add_development_dependency 'rspec', '2.12.0'
  gem.add_development_dependency 'gem_publisher', '1.2.0'
  gem.add_development_dependency 'faraday_middleware', '0.8.8' # had to pin for gem resolution to work on Jenkins
  gem.add_development_dependency "gemfury", '0.4.12'
  gem.add_development_dependency "webmock", '1.9.0'
end
