# frozen_string_literal: true

class CardActivityQuery < ApplicationQuery
  def call(filters: {})
    scope.extending(Scopes)
         .by_user(user_id: filters[:user_id])
         .by_card(card_id: filters[:card_id])
         .by_product(product_id: filters[:product_id])
         .by_brand(brand_id: filters[:brand_id])
         .by_client(client_id: filters[:client_id])
         .by_name(name: filters[:name])
         .by_from_datetime(from_datetime: filters[:from_datetime])
         .order(created_at: :desc)
  end

  module Scopes
    def by_user(user_id:)
      return CardActivity.none if user_id.blank?

      user = User.find(user_id)

      where(id: user.card_activities)
    end

    def by_card(card_id:)
      return self if card_id.blank?

      where(trackable_type: 'Card', trackable_id: card_id)
    end

    def by_product(product_id:)
      return self if product_id.blank?

      product = Product.find(product_id)

      where(id: product.card_activities.pluck(:id))
    end

    def by_brand(brand_id:)
      return self if brand_id.blank?

      brand = Brand.find(brand_id)

      where(id: brand.card_activities.pluck(:id))
    end

    def by_client(client_id:)
      return self if client_id.blank?

      client = Client.find(client_id)

      where(id: client.card_activities.pluck(:id))
    end

    def by_name(name:)
      return self if name.blank?

      where(name:)
    end

    def by_from_datetime(from_datetime:)
      return self if from_datetime.blank?

      where(created_at: [from_datetime..])
    end
  end
end
