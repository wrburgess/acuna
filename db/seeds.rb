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

# CREATE Widgets
puts "BEGIN: Create Widgets"
30.times do
  Widget.create(name: Faker::Book.title, staff_notes: Faker::Lorem.sentence)
end
puts "END:   Create Widgets, Widgets Count: #{Widget.count}"

# CREATE Titles
puts "BEGIN: Create Titles"
30.times do
  Title.create(name: Faker::Movie.title, staff_notes: Faker::Lorem.sentence)
end
puts "END:   Create Titles, Titles Count: #{Title.count}"

# CREATE Orders
puts "BEGIN: Create Order Items"
Order.all.each do
  title = Title.all.sample

  screener_request = ScreenerRequest.create(
    title: title,
    user: order.user,
    staff_notes: Faker::Lorem.sentence
  )

  widget = Widget.all.sample

  OrderItem.create(
    order: it,
    itemable: screener_request,
    amount: Faker::Number.between(from: 10000, to: 50000),
    staff_notes: Faker::Lorem.sentence
  )

  OrderItem.create(
    order: it,
    itemable: widget,
    amount: Faker::Number.between(from: 100, to: 5000),
    staff_notes: Faker::Lorem.sentence
  )
end
puts "END:   Create Order Items, OrderItems Count: #{OrderItem.count}"

# CREATE Orders
puts "BEGIN: Create Orders"
150.times do
  Order.create(
    user: User.all.sample,
    card_brand: Faker::Business.credit_card_type,
    card_last4: Faker::Business.credit_card_number,
    card_exp_month: Faker::Business.credit_card_expiry_date,
    card_exp_year: Faker::Business.credit_card_expiry_date,
    stripe_id: Faker::Alphanumeric.alphanumeric(number: 10),
    staff_notes: Faker::Lorem.sentence, archived_at: nil
  )
end
puts "END:   Create Orders, Orders Count: #{Order.count}"
