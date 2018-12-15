desc "Export small cafes to CSV and delete from database"
task :small_cafes_to_csv => :environment do
  begin
    puts "Begin export to CSV and delete..."
    to_csv_and_delete
    puts "Finish export to CSV and delete at #{Time.now}..."
  rescue => errors
    puts "-"*100
    puts errors
    puts errors.backtrace
  end
end

def to_csv_and_delete
  require 'csv'
  attributes = [:name, :address, :postal_code, :chairs, :category]
  csv_file = CSV.generate(headers: true) do |csv|
    csv << attributes
    cafes = StreetCafe.where("category like ?", "%small%")
    cafes.each do |cafe|
      csv << attributes.map{ |attr| cafe[attr] }
    end
    cafes.delete_all
  end
  File.open('public/small_cafes.csv', 'w') { |file| file.write(csv_file) }
end
