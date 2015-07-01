require 'yard'
require 'rspec/illustrate/version'
require 'rexml/document'

# Register the template
YARD::Templates::Engine.register_template_path File.join(File.dirname(__FILE__), '..', '..', '..', 'yard-template')
# Make sure *.rspec files are treated as HTML files if they are included as
# extra files (like test reports and such).
YARD::Templates::Helpers::MarkupHelper::MARKUP_EXTENSIONS[:html] << "rspec"


module YARD
  module Parser
    # Parses the output from the RSpec::Illustrate::YARD formatter (which is valid
    # html) and inserts the nodes into the corresponding CodeObject.
    class RSpecParser < YARD::Parser::Base

      def initialize(source, filename)
        @source = source
      end

      # @see YARD::Parser::Base#parse
      def parse
        document = REXML::Document.new(@source)
        document.elements.each("html/body/div") {|element|
          if (path = element.attributes["id"].sub(/^rspec_/, '')) then
            if codeobject = YARD::Registry.at(path) then
              # only grab the <div> that contains the child elements, and omit
              # caption since we already gave a Specification header.
              examples = element.elements["div[@class='rspec_example_group_children']"]
              (codeobject[:rspec] ||= []).concat(examples.to_a)
            else
              log.warn "Could not find code object for #{path}, adding it to top level namespace."
              (YARD::Registry.root[:rspec] ||= []).concat(element.to_a)
            end
          end
        }
        self
      end

      # @see YARD::Parser::Base#tokenize
      def tokenize
        []
      end

      # @see YARD::Parser::Base#enumerator
      def enumerator
        nil
      end
    end
  end
end

# Register the parser so YARD knows how to handle *.rspec files.
YARD::Parser::SourceParser.register_parser_type(:rspec_parser, YARD::Parser::RSpecParser, 'rspec')

