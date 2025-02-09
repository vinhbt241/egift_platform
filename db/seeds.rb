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
Brand.create(
  name: Faker::Company.unique.name,
  fields_attributes: [
    { name: 'number_of_employees', data: '150', field_type_id: int_field_type.id },
    { name: 'founded_at', data: '10/10/2010', field_type_id: datetime_field_type.id },
    { name: 'location', data: 'Ho Chi Minh city', field_type_id: string_field_type.id },
    { name: 'gross_profit', data: '1500000.55', field_type_id: decimal_field_type.id },
    { name: 'description', data: Faker::Lorem.paragraph, field_type_id: text_field_type.id }
  ],
  user: admin1
)
