# Rspec::Illustrate

This is an RSpec extension gem that allows you to define illustrative objects in
your examples that will be forwarded to the output formatter. This will allow
your output spec to become more readable, illustrative, and explanatory.


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

      illustrate given.to_s, :label=>"Given the array"
      illustrate expected.to_s, :label=>"After sort it looks like this"
      illustrate actual.to_s, :show_when_passed=>false

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


## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ErikSchlyter/rspec-illustrate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
