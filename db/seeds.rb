# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# CREATE Admins
puts "BEGIN: Create admins"
admins = [
  { email: "wrburgess@gmail.com", first_name: "Randy", last_name: "Burgess", password: "dtf6fhu7pdq6nbz-RED", confirmed_at: Time.now.utc }
]
admins.each do |admin|
  User.create_with(admin).find_or_create_by(email: admin[:email])
end
puts "END:   Create admins, Users Count: #{User.count}"

# CREATE Users
puts "BEGIN: Create users"
30.times do
  User.create(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: Faker::Internet.password,
    confirmed_at: Time.now.utc
  )
end
puts "END:   Create users, Users Count: #{User.count}"

# CREATE Links
puts "BEGIN: Create Links"
30.times do
  Link.create(url: Faker::Internet.url, url_type: UrlTypes.all.sample, secure_code: SecureRandom.hex(10), notes: Faker::Lorem.sentence)
end
puts "END:   Create Links, Links Count: #{Link.count}"
