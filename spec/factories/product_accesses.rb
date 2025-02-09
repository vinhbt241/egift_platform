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
FactoryBot.define do
  factory :product_access do
    association :product
    association :client
  end
end
