require 'virtus'

class Product
  include Virtus.model

  attribute :external_id, String
  attribute :url, String
  attribute :thumb_url, String
  attribute :price_changes, Array[PriceChange]
end
