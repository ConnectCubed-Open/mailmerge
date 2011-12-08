usage = "
Usage: bundle exec ruby #{__FILE__} <addresses.csv> <invites.txt>

 - selects the rows from addresses.csv where people chose to participate in beta
 - adds the 'invite' column and picks an invite from <invites.txt>
 - outputs to stdout
"

unless ARGV.size == 2
  puts usage
  exit(2)
end

begin
  require 'fastercsv'
rescue Exception
  puts usage
  exit(2)
end

csv_filename, invites_filename = ARGV[0], ARGV[1]

invites = File.readlines(invites_filename)
table = FasterCSV.read(csv_filename, :headers => true)

table.delete_if { |row| row["Are you interested in Beta-testing UltraTradr?"] !~ /^Yes/ }

table.each { |row| row["invite"] = invites.shift.chomp }

puts table.to_s
