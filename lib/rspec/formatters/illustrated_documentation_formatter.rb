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

                  return label << illustration[:text].to_s
                })
end

module RSpec
  module Formatters
    include RSpec::Core::Formatters

    # An extension to the {RSpec::Core::Formatters::DocumentationFormatter} that
    # renders the illustrations after each example. A title/label for each
    # illustration can be set by setting the label option (@see
    # RSpec::Illustrate#illustrate).
    # If you want to filter the illustrations based on the test result, you can use
    # the options show_when_passed, show_when_failed and show_when_pending.
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

      # @see RSpec::Core::Formatters::DocumentationFormatter#example_passed
      def example_passed(passed)
        super(passed)
        write_illustrations(passed, :show_when_passed, :illustration_passed)
      end

      # @see RSpec::Core::Formatters::DocumentationFormatter#example_failed
      def example_failed(failure)
        super(failure)
        write_illustrations(failure, :show_when_failed, :illustration_failed)
      end

      # @see RSpec::Core::Formatters::DocumentationFormatter#example_pending
      def example_pending(pending)
        super(pending)
        write_illustrations(pending, :show_when_pending, :illustration_pending)
      end

      # @private
      # Writes the filtered illustrations of an example to the output stream.
      #
      # @param notification [RSpec::Core::Notifications::ExampleNotification]
      #                     The example notificiation that contains the
      #                     illustrations.
      # @param filter_key   [Symbol]
      #                     The option that each illustration should have a truthy
      #                     value of if they are to be written
      # @param color_type   [Symbol]
      #                     The symbol that corresponds to a configurable color
      def write_illustrations(notification, filter_key, color_type)
        illustrations = filter(illustrations_of(notification), filter_key)
        return if illustrations.empty?

        output.puts colored(indented(formatted(illustrations)), color_type)
      end

      # @private
      # @param text [String] The text to be colored
      # @param color_type [Symbol]
      # @return [String] The text wrapped in color codes.
      def colored(text, color_type)
        RSpec::Core::Formatters::ConsoleCodes.wrap(text, color_type)
      end

      # @private
      # @param text [String]
      # @return [String] The text where each newline is properly indented.
      def indented(text)
        current_indentation << text.gsub(/\n/, "\n#{current_indentation}")
      end

      # @private
      # Convert the illustrations to a string using the configurable illustration
      # formatter {RSpec::Configuration#illustration_formatter}.
      # @param illustrations [Array<Hash>] The illustrations
      # @return [String] a text concatenation of the illustrations
      def formatted(illustrations)
        formatter_proc = RSpec.configuration.illustration_formatter

        illustrations.collect{|illustration|
          formatter_proc.call(illustration)
        }.join("\n")
      end

    end
  end
end

