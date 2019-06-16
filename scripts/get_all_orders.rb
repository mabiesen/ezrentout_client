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

# testing shows you just get a empty basket
def try_to_break_page_count
  get_page_orders(150) 
end

# should determine number of pages and query to get all orders
def get_all_orders
  return_array = []
  ctr = 0
  loop do
    ctr = ctr + 1
    res = get_page_orders(ctr)
    unless res['baskets'].empty?
      return_array.push(res['baskets'])
    else
      break
    end
  end
  return_array
end
