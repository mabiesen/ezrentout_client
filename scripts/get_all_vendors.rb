require 'net/http'
require 'uri'
require 'json'

def get_page_vendors(page=1)
  uri = URI.parse("https://lightmodifiersrental.ezrentout.com/assets/vendors.api?page=#{page}")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = ""
  request.set_form_data(
    "include_custom_fields" => "true",
  )

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  JSON.parse(response.body)
end

def get_specific_vendor(vendor_id)
  uri = URI.parse("https://lightmodifiersrental.ezrentout.com/vendors/#{vendor_id}.api")
  request = Net::HTTP::Get.new(uri)
  request["Token"] = ""
  request.set_form_data(
    "include_custom_fields" => "true",
  )

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  JSON.parse(response.body)
end

def get_all_vendors
  return_array = []
  ctr = 0
  loop do
    sleep(0.5)
    ctr = ctr + 1
    res = get_page_orders(ctr)
    unless res['vendor'].empty?
      return_array.push(res['vendor'])
    else
      break
    end
  end
  return_array.flatten
end
