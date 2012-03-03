require 'spec_helper'

describe MarketPrice do

  let!(:market_price) { create(:market_price) }

  it { should validate_presence_of(:symbol) }
  it { should validate_uniqueness_of(:symbol) }

  describe 'creation' do
    let(:market_price) { build(:market_price) }

    before { market_price.should_receive(:queue_update!) }

    it 'should enqueue a job to update itself upon creation' do
      market_price.save!
    end
  end

  describe '.get' do
    let(:symbol) { market_price.symbol }

    before do
      MarketPrice.should_receive(:find_by_symbol).with(symbol)
        .and_return(found)
    end

    context 'in the db' do
      let(:found) { market_price }

      context 'and fresh' do
        before do
          market_price.stub(:stale? => false)
          market_price.should_not_receive(:queue_update!)
        end
        specify { MarketPrice.get(symbol).should == market_price.price }
      end

      context 'and stale' do
        before do
          market_price.stub(:stale? => true)
          market_price.should_receive(:queue_update!)
        end
        specify { MarketPrice.get(symbol).should == market_price.price }
      end
    end

    context 'not in db yet' do
      let(:found) { nil }

      before do
        MarketPrice.should_receive(:create!).with(symbol: symbol)
          .and_return(market_price)
      end

      specify { MarketPrice.get(symbol).should == market_price.price }
    end
  end

  describe '#stale?' do
    before { market_price.stub(:updated_at => age.ago) }

    context '=> true' do
      let(:age) { MarketPrice::STALE_THRESHOLD + 1.minute }
      specify { market_price.should be_stale }
    end

    context '=> false' do
      let(:age) { MarketPrice::STALE_THRESHOLD - 1.minute }
      specify { market_price.should_not be_stale }
    end
  end
end
