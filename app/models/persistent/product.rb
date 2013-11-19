module Persistent
  class Product < ActiveRecord::Base
    has_many :price_changes, dependent: :delete_all
  end
end
