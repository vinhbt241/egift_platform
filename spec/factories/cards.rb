# frozen_string_literal: true

# == Schema Information
#
# Table name: cards
#
#  id                :uuid             not null, primary key
#  activation_number :string           not null
#  pin_number        :string           not null
#  status            :integer          default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_id         :uuid
#  product_id        :uuid
#
# Indexes
#
#  index_cards_on_client_id                         (client_id)
#  index_cards_on_pin_number_and_activation_number  (pin_number,activation_number) UNIQUE
#  index_cards_on_product_id                        (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#
FactoryBot.define do
  factory :card do
    association :client
    association :product
  end
end
