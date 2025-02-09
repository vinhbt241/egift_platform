# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
class CardActivityQuery < ApplicationQuery
  def call(filters: {})
    user = User.find(filters[:user_id])

    scope.extending(Scopes)
         .by_card(card_id: filters[:card_id])
         .by_product(product_id: filters[:product_id], user:)
         .by_brand(brand_id: filters[:brand_id], user:)
         .by_client(client_id: filters[:client_id], user:)
         .by_name(name: filters[:name])
         .by_from_datetime(from_datetime: filters[:from_datetime])
         .order(created_at: :desc)
  end

  module Scopes
    def by_card(card_id:)
      return self if card_id.blank?

      where(trackable_type: 'Card', trackable_id: card_id)
    end

    def by_product(product_id:, user:)
      return self if product_id.blank?

      product = user.products.find(product_id)

      where(id: product.card_activities.pluck(:id))
    end

    def by_brand(brand_id:, user:)
      return self if brand_id.blank?

      brand = user.brands.find(brand_id)

      where(id: brand.card_activities.pluck(:id))
    end

    def by_client(client_id:, user:)
      return self if client_id.blank?

      client = user.clients.find(client_id)

      where(id: client.card_activities.pluck(:id))
    end

    def by_name(name:)
      return self if name.blank?

      where(name:)
    end

    def by_from_datetime(from_datetime:)
      return self if from_datetime.blank?

      where(from_datetime: [from_datetime..])
    end
  end
end
# rubocop:enable Metrics/AbcSize
