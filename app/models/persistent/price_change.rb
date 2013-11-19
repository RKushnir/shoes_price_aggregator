module Persistent
  class PriceChange < ActiveRecord::Base
    belongs_to :product

    scope :recorded_before,
      ->(date) { where(arel_table[:recorded_on].lt(date)) }
    scope :newest,
      ->(count = nil) { order(arel_table[:recorded_on].desc).limit(count) }
  end
end
