require 'rspec/illustrate/version'
require 'rspec/core'

module RSpec
  # Extension module to RSpec that allows you to define illustrations in the
  # examples that will be forwarded to the output formatter.
  module Illustrate

    # Stores an object in the surrounding example's metadata, which can be used
    # by the output formatter as an illustration for the example.
    # @param content The object that will act as an illustration.
    # @param args [Array<Hash, Symbol>] Additional options.
    # @return The given illustration object.
    def illustrate(content, *args)
      illustration = { :content => content,
                       :show_when_passed  => true,
                       :show_when_failed => true,
                       :show_when_pending => true }

      args.each{|arg|
        illustration[arg] = true if arg.is_a?(Symbol)
        illustration.merge!(arg) if arg.kind_of?(Hash)
      }

      RSpec.current_example.metadata[:illustrations] << illustration
      content
    end
  end
end

RSpec.configure do |c|
  c.include RSpec::Illustrate
  c.before do
    RSpec.current_example.metadata[:illustrations] = []
  end
end

RSpec::SharedContext.send(:include, RSpec::Illustrate)
