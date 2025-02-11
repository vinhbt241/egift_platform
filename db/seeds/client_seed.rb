# frozen_string_literal: true

# generate a client for each user

User.find_each do |user|
  Client.create(
    name: Faker::Name.unique.name,
    password: '12345',
    user: user
  )
end
