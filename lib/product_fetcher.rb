require 'virtus'
require 'nokogiri'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

class ProductFetcher
  HOST = 'http://intertop.ua'

  class Product
    include Virtus.value_object

    values do
      attribute :external_id, String
      attribute :url, String
      attribute :thumb_url, String
      attribute :price, Integer
    end
  end

  def fetch_products
    connection = Faraday.new(url: HOST) do |faraday|
      faraday.adapter :typhoeus
    end

    connection.headers[:user_agent] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0"

    response = connection.get('/master')
    first_page = Nokogiri::HTML(response.body)
    last_paging_anchor = first_page.css('.paging a:not(.arr)').last
    last_paging_href = last_paging_anchor.attributes['href'].value
    page_count = last_paging_href.match(/&page=(\d+)/)[1].to_i

    products = parse_products(first_page)

    manager = Typhoeus::Hydra.new(max_concurrency: 10)

    # responses = nil
    # connection.in_parallel(manager) do
      responses = (2..page_count).map do |page|
        sleep(1)
        connection.get('/master', page: page)
      end
    # end

    responses.each do |response|
      page = Nokogiri::HTML(response.body)
      products.concat parse_products(page)
    end

    products
  end

  def parse_products(page)
    page.css('.one_item').map do |item|
      id        = item.attributes['id'].value.split('-').last
      price     = item.at_css('.new_price strong').child.text
      anchor    = item.at_css('.item_img')
      url       = HOST + anchor.attributes['href'].value
      thumb_url = HOST + anchor.at_css('img').attributes['data-original'].value

      Product.new(
        external_id: id,
        url:         url,
        thumb_url:   thumb_url,
        price:       price,
      )
    end
  end
end
