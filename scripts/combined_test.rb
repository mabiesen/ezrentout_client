require './get_all_orders.rb'
require './get_all_assets.rb'

all_assets = get_all_assets
all_orders = get_all_orders
completed_orders = all_orders.select{|z| z['basket_state'] != 'Drafted'}

puts completed_orders.count
