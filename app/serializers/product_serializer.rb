# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :uuid             not null, primary key
#  currency   :string(3)        not null
#  price      :decimal(21, 3)   not null
#  state      :integer          default("active")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :uuid
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#
class ProductSerializer < ApplicationSerializer
  identifier :id

  fields :state, :price, :currency, :brand_id

  association :fields, blueprint: FieldSerializer
end
