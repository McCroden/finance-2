require 'spec_helper'

describe 'adding, editing, listing stocks' do

  let(:user) { create(:user) }

  context 'the user has no stocks yet' do
    before { login user }

    it 'should allow adding a stock' do
      click_link 'Add a Stock'
      fill_in 'Ticker Symbol', with: 'AAPL'
      fill_in 'Shares',        with: '1000'
      fill_in 'Price Paid',    with: '100'
      click_button 'Add to My Portfolio'
      response.should contain('AAPL was added.')
    end
  end

  context 'the user has a couple stocks' do
    let!(:aapl) { create(:stock, symbol: 'AAPL', user: user) }
    let!(:msft) { create(:stock, symbol: 'MSFT', user: user) }

    before { login user }

    it 'should show the list of stocks' do
      response.should contain('AAPL')
      response.should contain('MSFT')
    end

    it 'should allow editing a stock' do
      within "#stock_#{aapl.id}" do |scope|
        scope.click_link 'Edit'
      end
      fill_in 'Shares', with: 123
      click_button
      aapl.reload.shares.should == 123
    end

    it 'should allow removing a stock' do
      within "#stock_#{msft.id}" do |scope|
        scope.click_link 'Remove', :method => :delete
      end
      response.should contain("#{msft.symbol} was removed.")
      Stock.exists?(msft.id).should be_false
    end
  end

end
