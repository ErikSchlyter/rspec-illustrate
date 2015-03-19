require 'rspec/illustrate'
require 'spec_helper'

module RSpec

  describe Illustrate do
    it "allows you to pass illustrative objects to the output formatter." do

      example_file = "spec/example.rb"

      given, result = execute_standalone_spec(example_file,
        "RSpec::Formatters::IllustratedDocumentationFormatter")

      illustrate given, :label=>"Given the file '#{example_file}'"
      illustrate result, :label=>"Output from the formatter"

      expect(result).to match("1 example, 0 failure")
    end

    context "when an example is executed from RSpec" do
      it "stores an empty list of illustrations (Hashes) in the metadata" do
        expect(RSpec.current_example.metadata).to have_key(:illustrations)
        expect(RSpec.current_example.metadata[:illustrations]).to be_a(Array)
        expect(RSpec.current_example.metadata[:illustrations]).to be_empty
      end
    end

    describe "#illustrate" do

      # the example illustration
      let!(:my_illustration) { illustrate "This is an example illustration" }

      # the hash that corresponds to :my_illustration
      let!(:the_hash) { RSpec.current_example.metadata[:illustrations].first }

      # This is a hack that removes the :my_illustration _after_ each example.
      # We want to run tests againts the example illustration, but we do not
      # want the example illustration under test to show up in the formatter.
      # Hence; after we are done testing we remove the first entry, which was
      # set by the let!-statement
      after do
        RSpec.current_example.metadata[:illustrations].shift
      end

      context "when invoked from within an RSpec example" do

        it "stores the illustration as a Hash in the list in the metadata" do
          expect(the_hash).to be_a(Hash)
        end

        describe "the Hash that corresponds to the illustration"do
          it "contains the content and the default settings" do
            illustrate the_hash.pretty_inspect

            expect(the_hash[:content]).to equal(my_illustration)
          end

          context "when providing arguments in the 'illustrate' statement" do
            let(:my_illustration) {
              illustrate "An example with arguments", :my_option, :my_arg=>42
            }

            it "should merge the arguments with the hash" do
              illustrate the_hash.pretty_inspect

              expect(the_hash[:my_option]).to be true
              expect(the_hash[:my_arg]).to be 42
            end
          end

        end
      end

    end
  end
end
