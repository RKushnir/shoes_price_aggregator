class ProductRepository
  class NullCallback
    def self.product_price_changed(*); end
  end

  def self.store(product, callback = NullCallback)
    record = Persistent::Product.
      where(external_id: product.external_id).
      first_or_create!(
        url:       product.url,
        thumb_url: product.thumb_url,
      )

    if record.price.present?
      old_price = record.price
      if product.price != old_price
        record.transaction do
          record.price_changes.create!(
            price:       record.price,
            recorded_on: record.price_recorded_on,
          )
          record.update_attributes!(
            price:             product.price,
            price_recorded_on: Date.today,
          )
        end

        callback.product_price_changed(product, old_price)
      end
    else
      record.update_attributes!(price: product.price)
    end
  end
end
