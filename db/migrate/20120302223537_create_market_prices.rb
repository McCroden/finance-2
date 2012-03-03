class CreateMarketPrices < ActiveRecord::Migration
  def change
    create_table :market_prices do |t|
      t.string :symbol,                                :null => false
      t.decimal :price, :precision => 12, :scale => 6, :null => true

      t.timestamps
    end

    add_index :market_prices, :symbol, :unique => true
  end
end
