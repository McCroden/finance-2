require 'spec_helper'

describe 'viewing the summary of the portfolio stats' do

  let(:user) { create(:user) }

  before { login user }

  context 'one stock initially worth $100' do
    before do
      user.stocks.create!(symbol: 'AAPL', price: 100, shares: 1)
      visit '/'
    end

    it 'should show original_value == 100' do
      within '#portfolio_original_value' do |scope|
        scope.should contain('$100')
      end
    end

    it 'should indicate that updates are pending' do
      within '#portfolio_current_value' do |scope|
        scope.should contain('Updating')
      end
      within '#portfolio_roi' do |scope|
        scope.should contain('Updating')
      end
    end

    specify { Delayed::Job.count.should_not be_zero }

    context 'after the asynchonous update' do
      before do
        mock_google(user.stocks.first.symbol)
        Delayed::Worker.new.work_off
        visit '/'
      end

      specify { Delayed::Job.count.should be_zero }

      it 'should show all the correct values' do
        within '#portfolio_original_value' do |scope|
          scope.should contain('$100')
        end
        within '#portfolio_current_value' do |scope|
          scope.should contain('$543.90')
        end
        within '#portfolio_roi' do |scope|
          scope.should contain('$443.90')
        end
      end
    end
  end

end
