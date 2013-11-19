class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :external_id
      t.string  :url
      t.string  :thumb_url
      t.integer :price
      t.date    :price_recorded_on

      t.timestamps
    end

    add_index :products, :external_id, unique: true
  end
end
