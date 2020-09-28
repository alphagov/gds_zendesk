require "rake"
require "rubocop/rake_task"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

desc "Linting for Ruby"
task lint: %i[rubocop] do
end

task default: %i[lint spec]
