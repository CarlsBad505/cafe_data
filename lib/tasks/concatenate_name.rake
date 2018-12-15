desc "Concatenate small and medium cafe names"
task :concatenate_medium_large_cafes => :environment do
  begin
    puts "Begin concatenating small and medium cafe names..."
    concatenate
    puts "Finish concatenating small and medium cafe names at #{Time.now}..."
  rescue => errors
    puts "-"*100
    puts errors
    puts errors.backtrace
  end
end


def concatenate
  cafes = StreetCafe.where("category like ? OR category like ?", "%medium%", "%large%")
  cafes.each do |cafe|
    prefix = cafe.category.split(' ')[1]
    cafe.update(
      name: "#{prefix} #{cafe.name}"
    )
  end
end
