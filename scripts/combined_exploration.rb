require './get_all_orders.rb'
require './get_all_assets.rb'

first_page_assets = get_page_assets
first_page_orders = get_page_orders

puts "Keys for first page assets"
puts first_page_assets.keys
puts "\n\n"

puts "Keys for first page orders"
puts first_page_orders.keys
puts "\n\n"

puts "Assets count"
puts first_page_assets['assets'].count
puts "\n\n"

puts "Orders count"
puts first_page_orders['baskets'].count
puts "\n\n"

puts "Asset page count, because available unlike orders"
puts first_page_assets['total_pages']
puts "\n\n"

puts "See what happens if we request too many pages from orders"
puts try_to_break_page_count
puts "\n\n"

puts "Example order"
puts first_page_orders['baskets'][0]
puts "\n\n"

puts "Example asset"
puts first_page_assets['assets'][0]
puts "\n\n"

puts "common attributes"
puts first_page_assets['assets'][0].keys & first_page_orders['baskets'][0].keys
