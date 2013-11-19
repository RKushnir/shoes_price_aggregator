require 'product_fetcher'

class FetchProductsJob
  class PriceChangeCallback
    attr_reader :price_changes

    def initialize(price_changes)
      @price_changes = price_changes
    end

    def product_price_changed(product, old_price)
      price_changes << {product: product, old_price: old_price}
    end
  end

  def perform
    price_changes = []
    callback = PriceChangeCallback.new(price_changes)
    products = ProductFetcher.new.fetch_products

    products.each do |product|
      ProductRepository.store(product, callback)
    end

    if price_changes.present?
      SubscriberRepository.find_each do |subscriber|
        notify(subscriber, price_changes)
      end
    end

    reschedule(1.day.from_now)
  end

  def notify(subscriber, price_changes)
    Notifier.prices_change_notification(subscriber, price_changes).deliver
  end

  def reschedule(time)
    Delayed::Job.enqueue self.class.new, run_at: time
  end
end
