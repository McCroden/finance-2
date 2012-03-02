class PortfolioController < ApplicationController

  def show
    @stocks = current_user.stocks
  end

end
