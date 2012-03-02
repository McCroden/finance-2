class StocksController < ApplicationController

  def new
    @stock = current_user.stocks.build

    respond_to do |format|
      format.html
      format.json { render json: @stock }
    end
  end

  def edit
    @stock = current_user.stocks.find(params[:id])
  end

  def create
    @stock = current_user.stocks.new(params[:stock])

    respond_to do |format|
      if @stock.save
        format.html { redirect_to portfolio_url, notice: "#{@stock.symbol} was added." }
        format.json { render json: @stock, status: :created, location: @stock }
      else
        format.html { render action: "new" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @stock = current_user.stocks.find(params[:id])

    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        format.html { redirect_to portfolio_url, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock = current_user.stocks.find(params[:id])
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to portfolio_url, notice: "#{@stock.symbol} was removed." }
      format.json { head :no_content }
    end
  end
end
