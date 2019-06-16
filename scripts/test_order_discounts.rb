require './get_all_orders.rb'

all_orders = get_all_orders

completed = all_orders.select{|z| z['order_state'] == 'Completed'}

puts "COMPLETED ORDER SUMMARY"
puts "\n\n"
completed.each do |z|
  puts "SEQUENCE NUMBER: #{z['sequence_num']}"
  puts "CREATED ON:  #{z['created_at']}"
  puts "ORDER DISCOUNT: #{z['order_discount']}"
  puts "ORDER TYPE: #{z['order_type']}"
  puts "FIXED ASSET RENTS: #{z['fixed_asset_rents']}"
  puts "\n\n"
end
