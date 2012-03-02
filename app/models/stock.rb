class Stock < ActiveRecord::Base

  belongs_to :user

  attr_accessible :symbol, :shares, :price

  validates :symbol, :presence => true

  [:shares, :price].each do |numeric|
    validates numeric, :presence => true, :format => /\A\d+(\.\d*)?\z/
  end

  def original_value
    shares * price
  end

  def roi
    current_value - original_value rescue nil
  end

  def current_value
    shares * current_price rescue nil
  end

  def current_price
    MarketPrice.get(symbol)
  end

end
