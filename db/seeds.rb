# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# preload default user accounts
admin1 = User.create!(email: 'admin1.egifthub@gmail.com', password: '12345')
User.create!(email: 'admin2.egifthub@gmail.com', password: '12345')

# create field types
int_field_type = FieldType.create!(name: 'integer')
datetime_field_type = FieldType.create!(name: 'datetime')
string_field_type = FieldType.create!(name: 'string')
decimal_field_type = FieldType.create!(name: 'decimal')
text_field_type = FieldType.create!(name: 'text')

# create brands
3.times do
  Brand.create(
    name: Faker::Company.unique.name,
    fields_attributes: [
      {
        name: 'number_of_employees',
        data: rand(1001).to_s,
        field_type_id: int_field_type.id
      },
      {
        name: 'founded_at',
        data: Faker::Time.between(from: DateTime.now - 20.years, to: DateTime.now - 1.year).to_s,
        field_type_id: datetime_field_type.id
      },
      {
        name: 'location',
        data: Faker::Address.city,
        field_type_id: string_field_type.id
      },
      {
        name: 'gross_profit',
        data: Faker::Number.decimal(l_digits: 6, r_digits: 2).to_s,
        field_type_id: decimal_field_type.id
      },
      {
        name: 'description',
        data: Faker::Lorem.paragraph,
        field_type_id: text_field_type.id
      }
    ],
    user: admin1
  )
end
