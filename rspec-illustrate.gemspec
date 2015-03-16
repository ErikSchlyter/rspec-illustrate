# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/illustrate/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-illustrate"
  spec.version       = Rspec::Illustrate::VERSION
  spec.authors       = ["Erik Schlyter"]
  spec.email         = ["erik@erisc.se"]

  spec.summary       = %q{RSpec extension gem for including illustrative objects in your specs.}
  spec.description   = %q{A plugin to RSpec that allows you to define illustrative objects in your examples that will be forwarded to the output formatter. This will allow your output spec to become more readable, illustrative, and explanatory.}
  spec.homepage      = "https://github.com/ErikSchlyter/rspec-illustrate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_dependency 'rspec-core', '~> 3.2.1'
  spec.add_dependency 'rspec-expectations', '~> 3.2.0'
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
