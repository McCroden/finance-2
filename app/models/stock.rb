class Stock < ActiveRecord::Base

  belongs_to :user

  attr_accessible :symbol, :shares, :price

  validates :symbol, :presence => true

  [:shares, :price].each do |numeric|
    validates numeric, :presence => true, :format => /\A\d+(\.\d*)?\z/
  end

end
