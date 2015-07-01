require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard/rake/yardoc_task'
require 'rspec/illustrate/yard'
require 'rake/clean'

desc "Execute RSpec and create a test report at ./tmp/api.rspec."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format RSpec::Formatters::IllustratedDocumentationFormatter --format RSpec::Formatters::YARD --out tmp/api.rspec'
end
CLEAN.include('tmp')

desc "Create documentation."
YARD::Rake::YardocTask.new(:doc) do |t|
    t.files   = ['lib/**/*.rb', 'tmp/api.rspec', '-', 'tmp/api.rspec']
end
CLOBBER.include("doc")
CLEAN.include(".yardoc")
task :doc => [:spec]

desc "Execute tests."
RSpec::Core::RakeTask.new(:test)

task :default => :test
