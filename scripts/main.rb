require './get_all_orders.rb'
require './get_all_vendors.rb'
require './get_all_assets.rb'

# First, fetch all of the orders
# From the order, iterate the assets
# From the assets, call to get specific asset detail
# Use vendor id in specific asset detail to find vendor
# 
# Fields will be:
# order_id(order)
# item_name(asset)
# vendor_name(vendor)
# total_rate(asset???)
# discount_rate(order)
# total (total_rate/2 - (total_rate/2 * %discount))
#
# NOTE: when looking at order fixed_assets, quantity duplicated
# One is misspelled

all_orders = get_all_orders
all_assets = get_all_assets

completed = all_orders.select{|z| z['order_state'] == 'Completed'}

completed.each do |order|
  order_id = order['sequence_num']
  discount_rate = order['order_discount']
  fixed_assets = order['fixed_asset_rents']
  customer_full_name = order['associated_customer']['full_name']
  employee_id = order['assigned_to_id']
  created_at = order['created_at']
  fixed_assets.each do |fa|
    sequence_number = fa['sequence_num']
    asset_name = fa['name']
    quantity = fa['quantity']
    rate = fa['rate']
    weekrate, dayrate = rate.split(',')
    weekrate_amount = weekrate.split('/')[0].gsub(/\$/,'').strip
    dayrate_amount = dayrate.split('/')[0].gsub(/\$/,'').strip
    fa_duration = fa['duration']
    fa_duration_amount, fa_duration_unit = fa_duration.split(' ')
    fa_duration_amount = fa_duration_amount.strip
    puts "FA DURATION AMOUNT #{fa_duration_amount}"
    puts "FA DURATION AMOUNT AS INT #{fa_duration_amount.to_i}"
    puts "DAYRATE AMOUNT #{dayrate_amount}"
    puts "DAYRATE AMOUNT AS FLOAT #{dayrate_amount.to_f}"
    gets
    if fa_duration_unit.downcase.include?('day')
      vendor_amount = (fa_duration_amount.to_i * dayrate_amount.to_f)/2
    else
      vendor_amount = (fa_duration_amount.to_i * weekrate_amount.to_f)/2
    end
    fa_price = fa['price']
    assets = all_assets.select{|a| a['sequence_num'] == sequence_number}
    assets.each do |asset|
      vendor_id = asset['vendor_id']
      vendor = get_specific_vendor(vendor_id)
      vendor_name = vendor['name']
      puts "CREATED AT: #{created_at}"
      puts "CREATED BY: #{employee_id}"
      puts "ORDER ID: #{order_id}"
      puts "CUSTOMER: #{customer_full_name}"
      puts "ORDER %discount: #{discount_rate}"
      puts "ITEM NAME: #{asset_name}"
      puts "VENDOR NAME: #{vendor_name}"
      puts "PRICE: #{fa_price}"
      puts "PER WEEK RATE: #{weekrate_amount}"
      puts "PER DAY RATE: #{dayrate_amount}"
      puts "DURATION AMOUNT: #{fa_duration_amount}"
      puts "DURATION UNIT: #{fa_duration_unit}"
      puts "VENDOR CUT(based on rate and duration): #{vendor_amount}"
      gets
    end
  end
end
