require 'delegate'

module EZRentout
  class Response < ::SimpleDelegator
    attr_reader :errors, :raw_body

    def initialize(body, errors = nil, raw_body = nil)
      super(body)
      @errors = errors
      @raw_body = raw_body
    end

    alias_method :value,  :__getobj__
    alias_method :value=, :__setobj__
  end
end
