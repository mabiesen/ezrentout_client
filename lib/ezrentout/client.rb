require File.join(File.dirname(__FILE__), 'client/orders')
require File.join(File.dirname(__FILE__), 'client/response')

require 'faraday'
require 'faraday_middleware'

module EZRentout
  class << self
    attr_accessor :base_url, :token
    attr_writer :client

    def make_request(uri, verb = :get, args = {})
      response = client.send(verb, uri, args) do |request|
        request.body = args.to_json
        request.headers['Content-Type'] = 'application/json'
      end

      json = JSON.parse(response.body)
      puts json

      Response.new(json['result'], json['errors'], response.body)
    end

    def get(uri, args)
      make_request(uri, :get, args)
    end

    def client
      @client ||= Faraday.new(base_url || "https://lightmodifiersrental.ezrentout.com", :ssl => {:verify => false}) do |conn|
        conn.request :json
        conn.token_auth(token)
        conn.adapter :net_http
      end
    end
  end
end
