require './get_all_assets.rb'
require './get_all_orders.rb'

puts "COUNT ALL ASSETS"
puts get_all_assets.count
puts "\n\n"

puts "COUNT ALL ORDERS"
all_orders = get_all_orders
puts get_all_orders.count
puts "\n\n"

puts "COUNT ALL ORDERS NOT DRAFTED STATE"
not_drafted = all_orders.select{|z| z['order_state'] == 'Completed'}
puts not_drafted.count
