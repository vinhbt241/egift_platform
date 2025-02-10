# frozen_string_literal: true

# generate three brands for each user

int_field_type = FieldType.find_or_create_by(name: 'integer')
datetime_field_type = FieldType.find_or_create_by(name: 'datetime')
string_field_type = FieldType.find_or_create_by(name: 'string')
decimal_field_type = FieldType.find_or_create_by(name: 'decimal')
text_field_type = FieldType.find_or_create_by(name: 'text')

User.find_each do |user|
  3.times do
    Brand.create!(
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
      user: user
    )
  end
end
