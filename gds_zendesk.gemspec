# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gds_zendesk/version'

Gem::Specification.new do |gem|
  gem.name          = "gds_zendesk"
  gem.version       = GdsZendesk::VERSION
  gem.authors       = ["Jake Benilov"]
  gem.email         = ["benilov@gmail.com"]
  gem.description   = %q{Client and models for communicating with Zendesk}
  gem.summary       = %q{Client and models for communicating with Zendesk}
  gem.homepage      = "https://github.com/alphagov/gds_zendesk"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake', '10.0.3'
end
