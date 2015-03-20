require 'rspec/formatters/illustration_formatter'

module RSpec

  describe Formatters do
    describe "#filter" do

      let(:test_illustrations) do
        { :illustration_1 => { :content           => "This is illustration 1",
                               :show_when_passed  => true,
                               :show_when_failed  => true,
                               :show_when_pending => true },
          :illustration_2 => { :content           => "This is illustration 2",
                               :show_when_passed  => false,
                               :show_when_failed  => true,
                               :show_when_pending => true },
          :illustration_3 => { :content           => "This is illustration 3",
                               :show_when_passed  => true,
                               :show_when_failed  => false,
                               :show_when_pending => true },
          :illustration_4 => { :content           => "This is illustration 4",
                               :show_when_passed  => true,
                               :show_when_failed  => true,
                               :show_when_pending => false}
        }
      end

      let(:test_illustration_list) { test_illustrations.keys }

      def filter(filter_key)
        RSpec::Formatters.filter(test_illustrations.values, filter_key)
      end

      def symbols_of(list_of_hashes)
        test_illustrations.select{|symbol, hash|
          list_of_hashes.include?(hash)
        }.keys
      end

      def expect_list(symbol, list)
        illustrate list.pretty_inspect,
                   :label=>"Expected when filtered by #{symbol.inspect})"

        expect(symbols_of(filter(symbol))).to eq list
      end

      it "should only return hashes where the key is set to true" do
        test_illustrations.each{|key,value|
          illustrate value.pretty_inspect, :label => "Given #{key}"
        }

        expect_list(:show_when_passed,  [:illustration_1,
                                         :illustration_3,
                                         :illustration_4 ])
        expect_list(:show_when_failed,  [:illustration_1,
                                         :illustration_2,
                                         :illustration_4 ])
        expect_list(:show_when_pending, [:illustration_1,
                                         :illustration_2,
                                         :illustration_3 ])
      end
    end
  end

end
