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
