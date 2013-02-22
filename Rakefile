require "rake"
require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require "gem_publisher"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Publish the gem"
task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("gds_zendesk.gemspec", :gemfury, :as => 'govuk')
  puts "Published #{gem}" if gem
end
