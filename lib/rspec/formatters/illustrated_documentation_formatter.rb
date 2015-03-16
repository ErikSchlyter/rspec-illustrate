RSpec::Support.require_rspec_core "formatters/documentation_formatter"
require 'rspec/formatters/illustration_formatter.rb'

RSpec.configure do |c|
  c.add_setting(:illustration_passed_color,  :default => :cyan)
  c.add_setting(:illustration_failed_color,  :default => :cyan)
  c.add_setting(:illustration_pending_color, :default => :cyan)

  color_map = RSpec::Core::Formatters::ConsoleCodes::CONFIG_COLORS_TO_METHODS
  color_map[:illustration_passed]  = :illustration_passed_color
  color_map[:illustration_failed]  = :illustration_failed_color
  color_map[:illustration_pending] = :illustration_pending_color

  c.add_setting(:illustration_formatter, :default =>
                lambda {|illustration|
                  label = illustration.has_key?(:label) ?
                    "--- #{illustration[:label].to_s} ---\n" : ""

                  return label << illustration[:content].to_s
                })
end

module RSpec
  module Formatters
    include RSpec::Core::Formatters

    class IllustratedDocumentationFormatter < DocumentationFormatter
      include RSpec::Formatters

      # This registers the notifications this formatter supports, and tells
      # us that this was written against the RSpec 3.x formatter API.
      RSpec::Core::Formatters.register self, :example_passed,
                                             :example_failed,
                                             :example_pending

      def initialize(output)
        super(output)
      end

      def example_passed(passed)
        super(passed)
        write_illustrations(passed, :show_when_passed, :illustration_passed)
      end

      def example_failed(failure)
        super(failure)
        write_illustrations(failure, :show_when_failed, :illustration_failed)
      end

      def example_pending(pending)
        super(pending)
        write_illustrations(pending, :show_when_pending, :illustration_pending)
      end

      def write_illustrations(notification, filter_key, color_type)
        illustrations = filter(illustrations_of(notification), filter_key)
        return if illustrations.empty?

        output.puts colored(indented(formatted(illustrations)), color_type)
      end

      def colored(text, color_type)
        RSpec::Core::Formatters::ConsoleCodes.wrap(text, color_type)
      end

      def indented(text)
        current_indentation << text.gsub(/\n/, "\n#{current_indentation}")
      end

      def formatted(illustrations)
        formatter_proc = RSpec.configuration.illustration_formatter

        illustrations.collect{|illustration|
          formatter_proc.call(illustration)
        }.join("\n")
      end

    end
  end
end

