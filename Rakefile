require "bundler/gem_tasks"
require 'rake/clean'
Bundler.setup

require "rspec/core/rake_task"
desc "Execute RSpec and create a test report at ./doc/api.rspec."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format RSpec::Formatters::YARD --out ./doc/api.rspec"
end

require 'yard'
require 'rspec/illustrate/yard'
desc "Create documentation."
YARD::Rake::YardocTask.new(:doc) do |t|
    t.files   = ['lib/**/*.rb', 'doc/api.rspec', '-', 'doc/api.rspec']
end
CLEAN.include("doc")
CLEAN.include(".yardoc")
task :doc => [:spec]

desc "Execute tests."
RSpec::Core::RakeTask.new(:test)

task :default => :test
