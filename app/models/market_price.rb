class MarketPrice < ActiveRecord::Base

  validates :symbol, :presence => true, :uniqueness => true

  STALE_THRESHOLD = 10.minutes

  def self.get(symbol)
    if mp = find_by_symbol(symbol)
      mp.queue_update! if mp.stale?
    else
      mp = create!(symbol: symbol)
    end
    mp.price
  end

  def stale?
    updated_at < STALE_THRESHOLD.ago
  end

  def queue_update!
    job = UpdateMarketPriceFromGoogle.new(symbol)
    Delayed::Job.enqueue(job)
  end

end
