require 'virtus'

class PriceChange
  include Virtus.value_object

  values do
    attribute :recorded_on, Date
    attribute :price, Integer
  end
end
