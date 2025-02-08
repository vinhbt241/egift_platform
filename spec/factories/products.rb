# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  currency   :string(3)        not null
#  price      :decimal(21, 3)   not null
#  state      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :uuid
#  user_id    :uuid
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#  index_products_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :product do
    price { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
    currency { Faker::Currency.code.downcase }
  end
end
