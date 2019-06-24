require 'csv'
require 'google_drive'

def to_google_drive(data_array, data_headers, file_name) 
  begin
    temp_file = Tempfile.new('file_to_upload.csv')

    CSV.open(temp_file.path, 'wb') do |csv|
      csv << data_headers
      data_array.each do |row|
        csv << row
      end
    end
  rescue => e
    puts "error creating temporary csv"
    temp_file.close
    raise e
  end

  begin
    session = GoogleDrive::Session.from_service_account_key('gd_config.json')

    file = session.upload_from_file(temp_file.path, file_name, :content_type => 'text/csv')

    file.acl.push({type: "user", email_address: "upandcomming88@gmail.com",role: "writer"})
  rescue => e
    puts "error pushing file to google drive"
    raise e
  ensure
    temp_file.close
  end
end
