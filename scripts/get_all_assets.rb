require 'net/http'
require 'uri'
require 'json'

def get_page_assets(page=nil)
  uri = URI.parse("https://lightmodifiersrental.ezrentout.com/assets.api?page=#{page || 1}")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = "8eaf20ad3f8a61b6e5685f188122ec25"
  request.set_form_data(
    "include_custom_fields" => "true",
    "show_document_details" => "true",
    "show_document_urls" => "true",
    "show_image_urls" => "true",
  )

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  JSON.parse(response.body)
end

# should determine pages, iterate all pages, return response
def get_all_assets
  get_page_assets['assets']
end
