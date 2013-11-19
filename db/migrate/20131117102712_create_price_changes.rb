class CreatePriceChanges < ActiveRecord::Migration
  def change
    create_table :price_changes do |t|
      t.references :product, index: true
      t.integer    :price
      t.date       :recorded_on

      t.timestamps
    end
  end
end
