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
csv_path = File.join(File.dirname(__FILE__), 'sources', 'seeds', 'mlb_teams.csv')

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
csv_path = File.join(File.dirname(__FILE__), 'sources', 'seeds', 'ppmlb_fantasy_baseball_teams.csv')

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

# Import Scouts
puts "Importing scouts..."

# Path to the CSV file
csv_path = File.join(File.dirname(__FILE__), 'sources', 'seeds', 'scouts.csv')

# Read the CSV file and process each row
CSV.foreach(csv_path, headers: true) do |row|
  first_name = row['first_name']
  last_name = row['last_name']
  company = row['company']

  # Find or create the scout record to prevent duplicates
  if scout = Scout.find_by(first_name:, last_name:)
    puts "Found existing scout: #{first_name} #{last_name} (#{company})"
  else
    Scout.create!(first_name:, last_name:, company:)
    puts "Created new scout: #{first_name} #{last_name} (#{company})"
  end
end

puts "Scouts import completed successfully!"

puts "Importing baseball levels..."

csv_path = File.join(File.dirname(__FILE__), 'sources', 'seeds', 'baseball_levels.csv')
CSV.foreach(csv_path, headers: true) do |row|
  name = row['name']
  abbreviation = row['abbreviation']
  weight = row['weight']

  next if abbreviation.nil? || abbreviation.empty?

  if level = Level.find_by(abbreviation: abbreviation)
    puts "Found existing baseball level: #{name} (#{abbreviation})"
  else
    Level.create!(name: name, abbreviation: abbreviation, weight: weight)
    puts "Created new baseball level: #{name} (#{abbreviation})"
  end
end

puts "Baseball levels import completed successfully!"

puts "Importing roster statuses..."

csv_path = File.join(File.dirname(__FILE__), 'sources', 'seeds', 'roster_statuses.csv')
CSV.foreach(csv_path, headers: true) do |row|
  name = row['name']
  abbreviation = row['abbreviation']
  weight = row['weight']

  next if abbreviation.nil? || abbreviation.empty?

  if status = Status.find_by(abbreviation: abbreviation)
    puts "Found existing roster status: #{name} (#{abbreviation})"
  else
    Status.create!(name: name, abbreviation: abbreviation, weight: weight)
    puts "Created new roster status: #{name} (#{abbreviation})"
  end
end

puts "Roster statuses import completed successfully!"
