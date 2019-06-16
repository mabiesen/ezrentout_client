require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://lightmodifiersrental.ezrentout.com/baskets.api")
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

puts JSON.parse(response.body)
