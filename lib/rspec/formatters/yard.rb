require 'rspec/formatters/illustration_formatter'
require 'rexml/document'

RSpec.configure do |c|
  c.add_setting(:title, :default => "RSpec results")
end

module RSpec
  module Formatters

    # An RSpec output formatter that writes in a specific HTML format that can
    # be imported by the YARD template. The output can also be viewed as a
    # stand-alone test report.
    class YARD
      include RSpec::Formatters

      # @return [String] the path to the CSS file in the YARD-template, which
      #                  will be imported into the header so the output HTML can
      #                  be viewed as a stand-alone document.
      CSS_FILE = File.join(File.dirname(__FILE__), '..','..','..',
                           'yard-template', 'default', 'fulldoc', 'html', 'css', 'rspec.css')

      RSpec::Core::Formatters.register self, :example_passed, :example_pending,
        :example_failed, :stop

      def initialize(output)
        @output = output
        @document = REXML::Document.new("<!DOCTYPE html>")

        html = @document.add_element("html")
        head = html.add_element("head")
        head.add_element("style").text = IO.read(CSS_FILE)
        @body = html.add_element("body")
      end

      # Called by RSpec for each example that passes.
      # @param passed [RSpec::Core::Notifications::ExampleNotification]
      def example_passed(passed)
        node = xml_node_for_notification(passed, :show_when_passed)
        node.attributes["class"] = "rspec_example_passed"
      end

      # Called by RSpec for each example that is pending.
      # @param pending [RSpec::Core::Notifications::ExampleNotification]
      def example_pending(pending)
        node = xml_node_for_notification(pending, :show_when_pending)
        node.attributes["class"] = "rspec_example_pending"
      end

      # Called by RSpec for each example that failes.
      # @param failure [RSpec::Core::Notifications::FailedExampleNotification]
      def example_failed(failure)
        node = xml_node_for_notification(failure, :show_when_pending)
        node.attributes["class"] = "rspec_example_failed"
        node.add_element("exception").text = failure.exception.message
        node.add_element("backtrace").text = failure.formatted_backtrace.join("\n")
      end

      # Called by RSpec when the test suite is complete.
      # @param notification [RSpec::Core::Notifications::ExamplesNotification]
      def stop(notification)
        @document.elements["html/head"].add_element("title").text =
          RSpec.configuration.title
        @document.write @output
      end

      private

      # @param notification[RSpec::Core::Notifications:ExampleNotification]
      # @return [REXML::Element] a new XML node that corresponds to the specific example.
      def xml_node_for_notification(notification, filter_key)
        example = notification.example
        node = xml_node_for_example_group(example.example_group).add_element("div")
        node.add_element("p", {'class'=>'rspec_example_paragraph'}).text = example.description

        filter(illustrations_of(notification), filter_key).each{|illustration|
          node.add_element(node_for_illustration(illustration))
        }

        node
      end

      # Creates a <div> node for the given illustration.
      # @param illustration [Hash] the illustration.
      # @return [REXML::Element] the XML node for the illustration.
      def node_for_illustration(illustration)
        node = REXML::Element.new("div")
        node.add_attribute('class', 'rspec_illustration')

        if label = illustration[:label] then
          node.add_element("p", {'class'=>'rspec_illustration_label'}).text = label
        end

        if illustration.has_key?(:html) then
          node.add_element(REXML::Document.new(illustration[:html]).root)
        else
          node.add_element("pre", {'class'=>'rspec_illustration_content'}).text =
            REXML::Text.new(illustration[:text], true, nil, false)
        end

        node
      end

      # @param example_group [RSpec::Core::ExampleGroup]
      # @return [REXML::Element] the XML node that corresponds to the specific example group,
      #                          which will be created if it doesn't exist.
      def xml_node_for_example_group(example_group)
        node = @body

        path = example_group.parent_groups.reverse
        if example_group.described_class then
          path = path.drop_while{|group|
            group.described_class != example_group.described_class
          }

          # use the class/module description as the YARD specific CodeObject id
          codeobject_id = path.shift.description

          # merge root with first element if it is a method.
          if path.size >= 1 && (path.first.description.start_with?('#')  ||
                                path.first.description.start_with?('.')) then
            codeobject_id = "#{codeobject_id}#{path.shift.description}"
          end

          # create first node with YARD-specific 'CodeObject' path as id.
          node = xml_child_node_for_group(codeobject_id, codeobject_id, @body)
        end

        path.inject(node){|node, group|
          xml_child_node_for_group(group.name, group.description, node)
        }
      end


      # @param id [String] the id of the node.
      # @param caption [String] the description of the node.
      # @param parent [REXML::Element] the parent node to search within.
      # @return [REXML::Element] the xml child node with the id and caption, which will be
      #                          created if it doesn't exist.
      def xml_child_node_for_group(id, caption, parent=@body)
        child_node = parent.elements["div[@id='rspec_#{id}']"]
        return child_node.elements["div[@class='rspec_example_group_children']"] if child_node

        child_node = parent.add_element "div", {'id' => "rspec_#{id}",
                                                'class'=>"rspec_example_group"}
        child_node.add_element("div", {'class'=>'rspec_example_group_title'}).text = caption
        child_node.add_element("div", {'class'=>'rspec_example_group_children'})
      end

    end

  end
end
