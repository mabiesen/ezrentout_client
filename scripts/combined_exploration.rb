require './get_all_orders.rb'
require './get_all_assets.rb'

first_page_assets = get_page_assets
first_page_orders = get_page_orders

puts "Keys for first page assets".upcase
puts first_page_assets.keys
puts "\n\n"

puts "Keys for first page orders".upcase
puts first_page_orders.keys
puts "\n\n"

puts "Assets count".upcase
puts first_page_assets['assets'].count
puts "\n\n"

puts "Orders count".upcase
puts first_page_orders['baskets'].count
puts "\n\n"

puts "Asset page count, because available unlike orders".upcase
puts first_page_assets['total_pages']
puts "\n\n"

puts "See what happens if we request too many pages from orders".upcase
puts try_to_break_page_count
puts "\n\n"

puts "Example order".upcase
puts first_page_orders['baskets'][0]
puts "\n\n"

puts "Example asset".upcase
puts first_page_assets['assets'][0]
puts "\n\n"

puts "common attributes".upcase
puts first_page_assets['assets'][0].keys & first_page_orders['baskets'][0].keys
puts "\n\n"

puts "Order keys".upcase
puts first_page_orders['baskets'][0].keys
puts "\n\n"

puts "Asset keys".upcase
puts first_page_assets['assets'][0].keys
puts "\n\n"
