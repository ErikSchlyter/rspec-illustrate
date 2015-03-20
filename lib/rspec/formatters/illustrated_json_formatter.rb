RSpec::Support.require_rspec_core "formatters/json_formatter"
require 'rspec/formatters/illustration_formatter.rb'

module RSpec
  module Formatters
    include RSpec::Core::Formatters

    # An extension to the {RSpec::Core::Formatters::JsonFormatter} that
    # includes the illustrations for each example.
    class IllustratedJsonFormatter < JsonFormatter
      include RSpec::Formatters

      RSpec::Core::Formatters.register self, :message, :dump_summary, :dump_profile, :stop, :close

      # @see RSpec::Core::Formatters::JsonFormatter#format_example
      def format_example(example)
        hash = super
        hash[:illustrations] = example.metadata[:illustrations] || []
        hash
      end
    end
  end
end

