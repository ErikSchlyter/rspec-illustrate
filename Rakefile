require "bundler/gem_tasks"
Bundler.setup
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format RSpec::Formatters::IllustratedDocumentationFormatter"
end

task :default => :spec
