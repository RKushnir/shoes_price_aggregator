require 'spec_helper'

describe "notifier/prices_change_notification.html.erb" do
  FakeProduct = Struct.new(:division, :url, :thumb_url, :price)

  def product(division)
    FakeProduct.new(division, "http://intertop.ua/#{division}/12345.html")
  end

  it "displays all the widgets" do
    assign(:price_changes, [
      {product: product("boys")},
      {product: product("girls")},
      {product: product("male")},
      {product: product("female")},
      {product: product("care")},
      {product: product("access")},
    ].shuffle)

    render

    expect("male").to appear_before("female")
    expect("female").to appear_before("boys")
    expect("boys").to appear_before("girls")
    expect("girls").to appear_before("access")
    expect("access").to appear_before("care")
  end
end
