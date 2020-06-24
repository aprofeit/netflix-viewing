require 'csv'
require 'chronic_duration'

INPUT_FILE = './data/raw_viewing_data.csv'
OUTPUT_FILE = './data/transformed_data.csv'

csv = CSV.read(INPUT_FILE, headers: true)
csv = csv.group_by do |row|
  row['Title'].split(':').first
end

counts = Hash.new(0)

csv.each do |(title, rows)|
  total_viewing_time = rows.sum do |row|
    ChronicDuration.parse(row['Duration'])
  end

  counts[title] = total_viewing_time
end

CSV.open(OUTPUT_FILE, 'w') do |csv|
  csv << ['Title', 'Time Watched', 'Duration (s)']
  counts.each do |(title, duration)|
    csv << [title, ChronicDuration.output(duration), duration]
  end
end
