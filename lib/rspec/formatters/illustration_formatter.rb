
module RSpec
  module Formatters

    def illustrations_of(notification)
      notification.example.metadata[:illustrations]
    end

    module_function :illustrations_of

    def filter(illustrations, filter_key)
      illustrations.select{|illustration| illustration[filter_key]}
    end

    module_function :filter

  end
end
