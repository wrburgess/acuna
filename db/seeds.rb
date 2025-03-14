require 'csv'

# CREATE Admins
puts "BEGIN: Create admins"
admins = [
  { email: "wrburgess@gmail.com", first_name: "Randy", last_name: "Burgess", password: "dtf6fhu7pdq6nbz-RED", confirmed_at: Time.now.utc },
]
admins.each do |admin|
  User.create_with(admin).find_or_create_by(email: admin[:email])
end
puts "END:   Create admins, Users Count: #{User.count}"

puts "Importing MLB teams..."

# Path to the CSV file
csv_path = File.join(File.dirname(__FILE__), 'sources', 'mlb_teams.csv')

# Read the CSV file and process each row
CSV.foreach(csv_path, headers: true) do |row|
  # Combine Location and Nickname into the name attribute
  name = "#{row['Location']} #{row['Nickname']}"
  abbreviation = row['Abbreviation']

  # Skip if abbreviation is empty
  next if abbreviation.nil? || abbreviation.empty?

  # Find or create the team record to prevent duplicates
  if team = Team.find_by(abbreviation: abbreviation)
    puts "Found existing team: #{name} (#{abbreviation})"
  else
    Team.create!(name: name, abbreviation: abbreviation)
    puts "Created new team: #{name} (#{abbreviation})"
  end
end

puts "MLB teams import completed successfully!"

# Import Fantasy Baseball Rosters
puts "Importing fantasy baseball rosters..."

# Path to the CSV file
csv_path = File.join(File.dirname(__FILE__), 'sources', 'ppmlb_fantasy_baseball_teams.csv')

# Read the CSV file and process each row
CSV.foreach(csv_path, headers: true) do |row|
  # Combine Location and Nickname into the name attribute
  name = "#{row['Location']} #{row['Nickname']}"
  abbreviation = row['Abbreviation']

  # Skip if abbreviation is empty
  next if abbreviation.nil? || abbreviation.empty?

  # Find or create the roster record to prevent duplicates
  if roster = Roster.find_by(abbreviation: abbreviation)
    puts "Found existing roster: #{name} (#{abbreviation})"
  else
    Roster.create!(name: name, abbreviation: abbreviation)
    puts "Created new roster: #{name} (#{abbreviation})"
  end
end

puts "Fantasy baseball rosters import completed successfully!"
