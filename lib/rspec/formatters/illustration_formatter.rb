
module RSpec
  module Formatters

    # @private
    # @param notification [RSpec::Core::Notifications::ExampleNotification]
    #        The example notification to be formatted.
    # @return [Array<Hash>] The list of illustrations in the example, where each
    #         illustration is represented by a { Hash } containing its properties.
    def illustrations_of(notification)
      notification.example.metadata[:illustrations] || []
    end

    module_function :illustrations_of

    # @private
    # @param illustrations [Array<Hash>] A list of illustrations ({ Hash })
    # @param filter_key [Symbol] The property that each illustration must have.
    # @return [Array<Hash>] The illustrations that have truthy property values for
    #                       filter_key.
    def filter(illustrations, filter_key)
      illustrations.select{|illustration| illustration[filter_key]}
    end

    module_function :filter

  end
end
