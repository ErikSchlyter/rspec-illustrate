require 'rspec/illustrate/version'
require 'rspec/core'

module RSpec
  module Illustrate

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
