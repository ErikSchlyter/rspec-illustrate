RSpec::Support.require_rspec_core "formatters/html_formatter"
require 'rspec/formatters/illustration_formatter.rb'

RSpec.configure do |c|
  c.add_setting(:illustration_html_formatter, :default =>
                lambda {|illustration|
                  html = "<dd>"

                  if illustration.has_key?(:label) then
                    html << "<span>#{illustration[:label].to_s}</span>"
                  end

                  content = illustration[:content]
                  if content.respond_to?(:to_html) then
                    html << content.to_html
                  else
                    html << "<pre>#{content.to_s}</pre>"
                  end

                  return html << "</dd>"
                })
end

module RSpec
  module Formatters
    include RSpec::Core::Formatters

    # An extension to the {RSpec::Core::Formatters::HtmlFormatter} that
    # renders the illustrations after each example. A title/label for each
    # illustration can be set by setting the label option (@see
    # RSpec::Illustrate#illustrate).
    # If you want to filter the illustrations based on the test result, you can use
    # the options show_when_passed, show_when_failed and show_when_pending.
    class IllustratedHtmlFormatter < HtmlFormatter
      include RSpec::Formatters

      # This registers the notifications this formatter supports, and tells
      # us that this was written against the RSpec 3.x formatter API.
      RSpec::Core::Formatters.register self, :example_passed,
                                             :example_failed,
                                             :example_pending

      def initialize(output)
        super(output)
      end

      # @see RSpec::Core::Formatters::HtmlFormatter#example_passed
      def example_passed(passed)
        super(passed)
        write_illustrations(passed, :show_when_passed)
      end

      # @see RSpec::Core::Formatters::HtmlFormatter#example_failed
      def example_failed(failure)
        super(failure)
        write_illustrations(failure, :show_when_failed)
      end

      # @see RSpec::Core::Formatters::HtmlFormatter#example_pending
      def example_pending(pending)
        super(pending)
        write_illustrations(pending, :show_when_pending)
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
      def write_illustrations(notification, filter_key)
        illustrations = filter(illustrations_of(notification), filter_key)
        return if illustrations.empty?

        output.puts formatted(illustrations)
      end

      # @private
      # Convert the illustrations to a string using the configurable illustration
      # html formatter {RSpec::Configuration#illustration_html_formatter}.
      # @param illustrations [Array<Hash>] The illustrations
      # @return [String] a html concatenation of the illustrations
      def formatted(illustrations)
        formatter_proc = RSpec.configuration.illustration_html_formatter

        illustrations.collect{|illustration|
          formatter_proc.call(illustration)
        }.join("\n")
      end

    end
  end
end

