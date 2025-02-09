# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CardActivityQuery do
  subject { described_class.new(CardActivity.all) }

  let!(:user) { create(:user) }

  let!(:brand_a) { create(:brand, user: user) }
  let!(:product_a) { create(:product, brand: brand_a) }
  let!(:client_a) { create(:client, user: user) }

  let!(:brand_b) { create(:brand, user: user) }
  let!(:product_b) { create(:product, brand: brand_b) }
  let!(:client_b) { create(:client, user: user) }

  describe '#call' do
    before do
      create(:card, client: client_a, product: product_a)
      create(:card, client: client_b, product: product_b)
    end

    context 'when filtering by user' do
      it 'returns card activities related to the user' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id })
        expect(result.pluck(:id)).to match_array(user.card_activities.pluck(:id))
      end
    end

    context 'when filtering by card_id' do
      let(:card) { create(:card, client: client_a, product: product_a) }

      it 'returns activities related to the specified card' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, card_id: card })
        expect(result.pluck(:id)).to match_array(card.card_activities.pluck(:id))
      end
    end

    context 'when filtering by product_id' do
      it 'returns activities related to the specified product' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, product_id: product_a.id })
        expect(result.pluck(:id)).to match_array(product_a.card_activities.pluck(:id))
      end
    end

    context 'when filtering by brand_id' do
      it 'returns activities related to the specified brand' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, brand_id: brand_a.id })
        expect(result.pluck(:id)).to match_array(brand_a.card_activities.pluck(:id))
      end
    end

    context 'when filtering by client_id' do
      it 'returns activities related to the specified client' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, client_id: client_a.id })
        expect(result.pluck(:id)).to match_array(client_a.card_activities.pluck(:id))
      end
    end

    context 'when filtering by name' do
      it 'returns activities with the specified name' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, name: 'CARD_CREATED' })
        expect(result.pluck(:id)).to match_array(user.card_activities.where(name: 'CARD_CREATED').pluck(:id))
      end
    end

    context 'when filtering by from_datetime' do
      it 'returns activities from the specified datetime onwards' do
        result = described_class.call(scope: CardActivity.all, filters: { user_id: user.id, from_datetime: 2.days.ago })
        expect(result.pluck(:id)).to match_array(user.card_activities.where(created_at: [2.days.ago..]).pluck(:id))
      end
    end
  end
end
