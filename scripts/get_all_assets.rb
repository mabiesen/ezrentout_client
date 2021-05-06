require 'net/http'
require 'uri'
require 'json'

def get_page_assets(page=1)
  uri = URI.parse("https://lightmodifiersrental.ezrentout.com/assets.api?page=#{page}")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = ""
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


def get_specific_asset(asset_id)
  uri = URI.parse("https://light_modifiers_rental.ezrentout.com/assets/1.api")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = ""
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
  return_array = []
  ctr = 0
  loop do
    sleep(0.5)
    ctr = ctr + 1
    res = get_page_assets(ctr)
    unless res['assets'].empty?
      return_array.push(res['assets'])
    else
      break
    end
  end
  return_array.flatten
end
