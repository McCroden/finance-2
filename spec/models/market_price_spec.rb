require 'spec_helper'

describe MarketPrice do

  let!(:market_price) { create(:market_price) }

  it { should validate_presence_of(:symbol) }
  it { should validate_uniqueness_of(:symbol) }

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
