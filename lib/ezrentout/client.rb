

require 'faraday'
require 'faraday_middleware'

module EZRentout
  class << self
    attr_accessor :base_url, :user_name, :password
    attr_writer :client

    def make_request(uri, verb = :get, args = {})
      response = client.send(verb, uri, args) do |request|
        request.body = args.to_json unless verb == :get
        request.headers['Content-Type'] = 'application/json'
      end

      json = JSON.parse(response.body)

      Response.new(json['result'], json['errors'], response.body)
    end

    def get(uri, args)
      make_request(uri, :get, args)
    end

    private

    def client
      @client ||= Faraday.new(base_url) do |conn|
        conn.request :json
        conn.basic_auth(user_name, password)
        conn.adapter :net_http
      end
    end
  end
end
