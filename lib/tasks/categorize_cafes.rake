desc "Categorize street cafes"
task :categorize_street_cafes => :environment do
  begin
    puts "Begin categorizing street cafes..."
    categorize
    puts "Finish categorizing street cafes at #{Time.now}..."
  rescue => errors
    puts "-"*100
    puts errors
    puts errors.backtrace
  end
end

def categorize
  ls2_50th_percentile = calculate_ls2_percentile
  cafes = StreetCafe.all
  cafes.each do |cafe|
    postal_code = cafe.postal_code.split(' ')
    prefix = postal_code[0]
    if prefix == 'LS1'
      cafe.update(category: 'ls1 small') if cafe.chairs < 10
      cafe.update(category: 'ls1 medium') if cafe.chairs >= 10 && cafe.chairs < 100
      cafe.update(category: 'ls1 large') if cafe.chairs >= 100
    elsif prefix == 'LS2'
      cafe.update(category: 'ls2 small') if cafe.chairs < ls2_50th_percentile
      cafe.update(category: 'ls2 large') if cafe.chairs >= ls2_50th_percentile
    else
      cafe.update(category: 'other')
    end
  end
end

def calculate_ls2_percentile
  arr = []
  cafes = StreetCafe.where("postal_code like ?", "%LS2%")
  cafes.each do |cafe|
    arr << cafe.chairs
  end
  arr.sort!
  i = arr.length * 0.5
  if i % 1 != 0 # <-- we know that i is a decimal and we should round up
    idx = (i + 1).to_i - 1
    return arr[idx]
  else # <-- we know that i is a whole number
    idx = i - 1
    puts (arr[idx] + arr[idx + 1]) / 2
    return (arr[idx] + arr[idx + 1]) / 2
  end
end
