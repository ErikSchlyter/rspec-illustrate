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

module FormatterSpecHelper
  def formatter
    RSpec.configuration.send setting
  end

  def set_formatter(formatter_proc)
    assign_formatter_sym = setting.to_s.concat('=').to_sym
    RSpec.configuration.send(assign_formatter_sym, formatter_proc)
  end

  shared_examples "a formatter configuration" do

    let(:custom_formatter) do
      lambda { |illustration|
        return "custom <#{illustration[:text].to_s}> custom"
      }
    end

    let!(:old_formatter) { formatter }
    after { set_formatter(old_formatter) }

    it "should return a Proc" do
      expect(formatter).to be_a(Proc)
    end

    it "should take an illustration Hash and return a text representation" do
      actual = formatter.call(illustration)

      expect(actual).to be_a(String)
      expect(actual).to eq(expected)
    end

    it "should be configurable by assigning a new proc" do
      set_formatter(custom_formatter)

      actual = formatter.call(illustration)

      expect(actual).to be_a(String)
      expect(actual).to eq(custom_expected)
    end
  end
end
