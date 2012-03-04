require 'spec_helper'

describe Portfolio do

  def a_stock
    build(:stock, price: 10, shares: 1).tap do |s|
      s.stub(:current_price => 12)
    end
  end

  let(:stocks) { Array.new(5) { a_stock } }

  subject { Portfolio.new(stocks) }

  describe 'should behave like an array of Stocks' do
    its(:size) { should == 5 }

    it 'should delegate .each to the stock array' do
      subject.each {|s| s.should be_a(Stock)}
    end
  end

  describe '.original_value' do
    its(:original_value) { should == 50 }
  end

  describe '.current_value' do
    its(:current_value) { should == 60 }
  end

  describe '.roi' do
    its(:roi) { should == 10 }
  end

  context 'with a new stock (current_price == nil)' do
    before { subject << build(:stock) }

    its(:original_value) { should_not be_nil }
    its(:current_value)  { should     be_nil }
    its(:roi)            { should     be_nil }
  end

end
