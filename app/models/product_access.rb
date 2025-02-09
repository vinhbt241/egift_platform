# frozen_string_literal: true

# == Schema Information
#
# Table name: product_accesses
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :uuid
#  product_id :uuid
#
# Indexes
#
#  index_product_accesses_on_client_id                 (client_id)
#  index_product_accesses_on_product_id                (product_id)
#  index_product_accesses_on_product_id_and_client_id  (product_id,client_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#
class ProductAccess < ApplicationRecord
  # associations
  belongs_to :product
  belongs_to :client

  # validations
  validates :product_id, uniqueness: { scope: :client_id }
  validate :client_can_access_product

  def client_can_access_product
    return if client&.user_id == product&.brand&.user_id

    errors.add(:client_id, 'maybe outside of user scope')
    errors.add(:product_id, 'maybe outside of user scope')
  end
end
