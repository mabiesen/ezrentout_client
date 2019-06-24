require './get_all_orders.rb'
require './get_all_assets.rb'
require './file_to_google_drive.rb'

# total (total_rate/2 - (total_rate/2 * %discount))

# NOTE: when looking at order fixed_assets, quantity duplicated
# One is misspelled

def get_duration_detail(fa_duration)
  begin
    fa_duration_amount, fa_duration_unit = fa_duration.split(' ')
    return fa_duration_amount, fa_duration_unit
  rescue
    fa_duration_amount = 0
    fa_duration_unit = 'Days'
    return fa_duration_amount, fa_duration_unit
  end
end

def get_rate_detail(rate)
  begin 
    weekrate, dayrate = rate.split(',')
    weekrate_amount = weekrate.split('/')[0].gsub(/\$/,'').strip
    dayrate_amount = dayrate.split('/')[0].gsub(/\$/,'').strip
    return [ weekrate, dayrate, weekrate_amount, dayrate_amount ]
  rescue
    return [0,0,0,0]
  end
end

def get_vendor_amount(fa_duration_unit, fa_duration_amount, weekrate_amount, dayrate_amount)
  begin
    unless fa_duration_amount.nil?
      fa_duration_amount = fa_duration_amount.to_s.strip
      if fa_duration_unit.downcase.include?('day')
        vendor_amount = (fa_duration_amount.to_i * dayrate_amount.to_f)/2
      else
        vendor_amount = (fa_duration_amount.to_i * weekrate_amount.to_f)/2
      end
    end
    return vendor_amount
  rescue
    puts "FAIL. duration_unit: #{fa_duration_unit}, duration_amount: #{fa_duration_amount}, weekrate: #{weekrate_amount}, dayrate: #{dayrate_amount}"
    gets
    return 0
  end
end

csv_list = []

begin 
  all_orders = get_all_orders
  all_assets = get_all_assets
rescue => e
  puts "error fetching all orders and assets"
end

completed = all_orders.select{|z| z['order_state'] == 'Completed'}

begin
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
      weekrate, dayrate, weekrate_amount, dayrate_amount = get_rate_detail(rate)
      fa_duration = fa['duration']
      fa_duration_amount, fa_duration_unit = get_duration_detail(fa_duration)
      vendor_amount = get_vendor_amount(fa_duration_unit, fa_duration_amount, weekrate_amount, dayrate_amount)
      fa_price = fa['price']
      assets = all_assets.select{|a| a['sequence_num'] == sequence_number}
      assets.each do |asset|
        #requires calls to get_specific_vendor
        #vendor_id = asset['vendor_id']
        #vendor_name = vendor['name']
        puts "CREATED AT: #{created_at}"
        puts "CREATED BY: #{employee_id}"
        puts "ORDER ID: #{order_id}"
        puts "CUSTOMER: #{customer_full_name}"
        puts "ORDER %discount: #{discount_rate}"
        puts "ITEM NAME: #{asset_name}"
        puts "PRICE: #{fa_price}"
        puts "PER WEEK RATE: #{weekrate_amount}"
        puts "PER DAY RATE: #{dayrate_amount}"
        puts "DURATION AMOUNT: #{fa_duration_amount}"
        puts "DURATION UNIT: #{fa_duration_unit}"
        puts "VENDOR CUT(based on rate and duration): #{vendor_amount}"
        puts "\n\n\n"
        csv_list.push([created_at, employee_id, order_id, discount_rate, asset_name, fa_price, weekrate_amount, dayrate_amount, fa_duration_amount, fa_duration_unit, vendor_amount]) 
      end
    end
  end
rescue => e
  puts "error getting specific data, may or may not be api related"
  raise e
end


headers = %w[CREATED_AT CREATED_BY ORDER_ID ORDER_DISCOUNT(%) ITEM_NAME PRICE PER_WEEK_RATE PER_DAY_RATE DURATION_AMOUNT DURATION_UNIT VENDOR_CUT]

filename = "#{Date.today.to_s}_order_report"

to_google_drive(csv_list, headers, filename)
