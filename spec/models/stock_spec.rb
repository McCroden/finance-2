require 'spec_helper'

describe Stock do

  it { should belong_to(:user) }

  it { should_not allow_mass_assignment_of(:user_id) }

  [:symbol, :shares, :price].each do |attribute|
    it { should validate_presence_of(attribute) }
    it { should allow_mass_assignment_of(attribute) }
  end

  [10, 10.1234, '10', '10.1234', 0, '0'].each do |val|
    it { should allow_value(val).for(:price) }
    it { should allow_value(val).for(:shares) }
  end

  ['NaN', nil, '', '   '].each do |val|
    it { should_not allow_value(val).for(:price) }
    it { should_not allow_value(val).for(:shares) }
  end


  describe '#original_value, #current_value, #roi' do
    subject { build(:stock, shares: 10, price: 2) }

    before { subject.stub(:current_price => 5) }

    its(:original_value) { should == 20 }
    its(:current_value)  { should == 50 }
    its(:roi)            { should == 30 }

    context 'the market price is not known yet' do
      before { subject.stub(:current_price => nil) }

      its(:current_value) { should be_nil }
      its(:roi)           { should be_nil }
    end
  end

end
