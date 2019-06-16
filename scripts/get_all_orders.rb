require 'net/http'
require 'uri'
require 'json'

def get_page_orders(page=nil)
  uri = URI.parse("https://lightmodifiersrental.ezrentout.com/baskets.api?page=#{page || 1}")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = "8eaf20ad3f8a61b6e5685f188122ec25"
  request.set_form_data(
    "filters[all]" => "all",
  )

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  JSON.parse(response.body)
end

# should determine number of pages and query to get all orders
def get_all_orders
  get_page_orders['baskets']
end
