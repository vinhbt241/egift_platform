# frozen_string_literal: true

# generate three products for each brand

string_field_type = FieldType.find_or_create_by(name: 'string')

Brand.find_each do |brand|
  3.times do
    Product.create!(
      brand_id: brand.id,
      price: Money.new(rand(500), 'USD'),
      currency: 'usd',
      fields_attributes: [
        {
          name: 'name',
          data: Faker::Food.vegetables,
          field_type_id: string_field_type.id
        }
      ]
    )
  end
end
