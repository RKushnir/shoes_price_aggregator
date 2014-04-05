require_relative '../../lib/product_fetcher.rb'

describe ProductFetcher::Product do
  def product(division)
    ProductFetcher::Product.new(url: "http://intertop.ua/#{division}/12345.html")
  end

  describe "#division" do
    it "extracts division from url" do
      expect(product("female").division).to eq("female")
      expect(product("male"  ).division).to eq("male")
    end
  end
end
