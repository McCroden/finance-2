require 'spec_helper'

describe UpdateMarketPriceFromGoogle do

  describe '#perform' do
    let(:market_price) { build(:market_price) }
    let(:job) { UpdateMarketPriceFromGoogle.new(market_price.symbol) }

    before do
      MarketPrice.stub(:find_by_symbol => market_price)
      market_price.stub(:stale? => staleness)
      job.stub(:query_google => 10)
    end

    context 'still stale' do
      let(:staleness) { true }

      before { market_price.should_receive(:update_attribute).with(:price, 10) }

      # run the job to exercise the message expectations:
      specify { job.perform }
    end

    context 'updated since the job was enqueued' do
      let(:staleness) { false }

      before { market_price.should_not_receive(:update_attribute) }

      # run the job to exercise the message expectations:
      specify { job.perform }
    end
  end


  describe '#query_google' do
    let(:job) { UpdateMarketPriceFromGoogle.new('AAPL') }

    before { mock_google('AAPL') }

    it 'should read the latest price from the retrieved data' do
      job.send(:query_google).should == '543.90'
    end
  end

end
