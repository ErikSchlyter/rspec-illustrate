require "rspec/core/rake_task"
require 'rspec/illustrate/yard'
require 'rake/clean'

desc "Execute RSpec tests."
RSpec::Core::RakeTask.new(:test)

desc "Execute RSpec and create a test report at ./tmp/api.rspec."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format RSpec::Formatters::IllustratedDocumentationFormatter --format RSpec::Formatters::YARD --out tmp/api.rspec'
end
CLEAN << 'tmp'

desc "Create documentation."
YARD::Rake::YardocTask.new(:doc) do |t|
    t.files   = ['lib/**/*.rb', 'tmp/api.rspec', '-', 'tmp/api.rspec']
end
CLOBBER << 'doc'
CLEAN << '.yardoc'
task :doc => [:spec]

desc "List code that is undocumented."
YARD::Rake::YardocTask.new(:undoc) do |t|
  t.stats_options = ['--list-undoc']
end

task :default => :test
