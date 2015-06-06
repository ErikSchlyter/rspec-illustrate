# RSpec-illustrate [![Gem Version](https://badge.fury.io/rb/rspec-illustrate.svg)](http://badge.fury.io/rb/rspec-illustrate)

A plugin to RSpec and YARD that allows you to define illustrative objects in
your examples that will be forwarded to the output formatter. The results can be
imported into YARD, which makes your generated specs and documentation more
readable, illustrative, and explanatory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-illustrate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-illustrate

## Usage

Within an example you use the `illustrate` statement to define an object that
will be passed to the output formatter. You can also provide additional options
if you want to set a label or define when the formatter should write the
illustration (e.g. omit if the example fails, etc.)

Given the file `./spec/array_spec.rb`:

```ruby
require 'rspec/illustrate'

describe Array do
  describe "#sort" do
    it "should sort the array" do
      given = [3, 1, 2]
      expected = [1, 2, 3]
      actual = given.sort

      illustrate given, :label=>"Given the array"
      illustrate expected, :label=>"After sort it looks like this"
      illustrate actual, :show_when_passed=>false

      expect(actual).to eq(expected)
    end
  end
end
```

You execute RSpec with a formatter that takes the illustrations into
consideration, i.e.:

    $ rspec -f RSpec::Formatters::IllustratedDocumentationFormatter

The output would be something like this:

```
Array
  #sort
    should sort the array
    --- Given the array ---
    [3, 1, 2]
    --- After sort it looks like this ---
    [1, 2, 3]
```

## Import test results and illustrations into YARD

RSpec-Illustrate comes with a template for YARD and an RSpec formatter that
outputs a specific HTML format that the template can import.

To create the test report you have to execute RSpec with the specific formatter.
You need to add the following to your `Rakefile`:
```ruby
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format RSpec::Formatters::YARD --out ./doc/api.rspec"
end
```

Keep in mind that the file must end with `.rspec` in order for the template to
understand it's an RSpec output file. You load the template by invoking `require
rspec/illustrate/yard` and you import it by giving it to YARD as a normal input
file. Add the following to your `Rakefile`:

```ruby
require 'yard'
require 'rspec/illustrate/yard'
YARD::Rake::YardocTask.new(:doc) do |t|
    t.files   = ['lib/**/*.rb', 'doc/api.rspec']
end
task :doc => [:spec]
```

You can also include it as an extra file if you want to view it as a complete
test report (it is HTML after all). Simply add it to the list of extra files by
adding it after the `-` sign:

```ruby
require 'yard'
require 'rspec/illustrate/yard'
YARD::Rake::YardocTask.new(:doc) do |t|
    t.files   = ['lib/**/*.rb', 'doc/api.rspec', '-', 'doc/api.rspec']
end
task :doc => [:spec]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `rake install`. To release a
new version, update the version number in `version.rb`, and then run `rake
release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ErikSchlyter/rspec-illustrate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
