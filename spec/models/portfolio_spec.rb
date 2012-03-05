require 'spec_helper'

shared_examples_for 'an Array of Stocks' do
  it 'should delegate .size to the array' do
    subject.size.should == stocks.size
  end
  it 'should delegate .each to the array' do
    subject.each {|s| s.should be_a(Stock)}
  end
end

describe Portfolio do

  def a_stock
    build(:stock, price: 10, shares: 1).tap do |s|
      s.stub(current_price: 12)
    end
  end

  subject { Portfolio.new(stocks) }

  context 'with 5 existing stocks' do
    let(:stocks) { Array.new(5) { a_stock } }

    it_behaves_like 'an Array of Stocks'

    its(:original_value) { should == 50 }
    its(:current_value)  { should == 60 }
    its(:roi)            { should == 10 }
  end

  context 'with some old and a new stock (current_price == nil)' do
    let(:stocks) { [a_stock, a_stock, build(:stock)] }

    it_behaves_like 'an Array of Stocks'

    its(:original_value) { should_not be_nil }
    its(:current_value)  { should     be_nil }
    its(:roi)            { should     be_nil }
  end

  context 'with no stocks yet' do
    let(:stocks) { [] }

    it_behaves_like 'an Array of Stocks'

    its(:original_value) { should be_zero }
    its(:current_value)  { should be_zero }
    its(:roi)            { should be_zero }
  end

  context 'with just one (new) stock' do
    let(:stocks) { [build(:stock)] }

    it_behaves_like 'an Array of Stocks'

    its(:original_value) { should_not be_zero }
    its(:current_value)  { should be_nil }
    its(:roi)            { should be_nil }
  end
end
