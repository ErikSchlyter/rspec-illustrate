require 'rspec/core/rake_task'
require 'tempfile'

def execute_standalone_spec(spec_file, formatter)

  temp_file = Tempfile.new('example')

  task = RSpec::Core::RakeTask.new
  task.pattern = spec_file
  task.rspec_opts = "--no-color --format #{formatter} --out #{temp_file.path}"
  task.run_task false

  input = File.open(spec_file).read
  output = File.open(temp_file.path).read

  temp_file.close

  return input, output
end
