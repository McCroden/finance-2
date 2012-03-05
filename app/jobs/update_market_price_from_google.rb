class UpdateMarketPriceFromGoogle < Struct.new(:symbol)

  def perform
    mp = MarketPrice.find_by_symbol(symbol)
    mp.update_attribute(:price, query_google) if mp.stale?
  end


  private

  def query_google
    resp = HTTParty.get('http://www.google.com/ig/api', query: {stock: symbol}).parsed_response
    resp['xml_api_reply']['finance']['last']['data']
  end
end
