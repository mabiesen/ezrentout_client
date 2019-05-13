module EZRentout
  class Orders
    class << self
      def uri
        '/baskets.api'.freeze
      end

      def all
        EZRentout.get(uri, :sysparm_query => 'page=1') # default is 1
      end
    end
  end
end
