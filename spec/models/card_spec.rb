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
require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { create(:card) }

  describe 'validations' do
    let(:client) { create(:client) }
    let(:product) { create(:product) }

    it { is_expected.to validate_uniqueness_of(:pin_number).scoped_to(:activation_number) }

    # rubocop:disable Rails/SkipsModelValidations
    context 'when validate can_active' do
      let(:card) { create(:card, client: client, product: product, status: :created) }

      it 'allows activation when the card is in created status' do
        card.status = :active
        expect(card).to be_valid
      end

      it 'does not allow activation if the previous status is not created' do
        card.update_columns(status: :redeemed)
        card.status = :active
        expect(card).not_to be_valid
      end

      it 'create error messsage if the previous status is not created' do
        card.update_columns(status: :redeemed)
        card.status = :active
        card.valid?
        expect(card.errors[:status]).to include('can not be activated')
      end
    end

    context 'when validate can_redeem' do
      let(:card) { create(:card, client: client, product: product, status: :active) }

      it 'allows redemption when the card is in active status' do
        card.status = :redeemed
        expect(card).to be_valid
      end

      it 'does not allow redeeming if the previous status is not active' do
        card.update_columns(status: :created)
        card.status = :redeemed
        expect(card).not_to be_valid
      end

      it 'create error messsage if the previous status is not active' do
        card.update_columns(status: :created)
        card.status = :redeemed
        card.valid?
        expect(card.errors[:status]).to include('can not be redeemed')
      end
    end

    context 'when validate can_cancel' do
      let(:card) { create(:card, client: client, product: product) }

      it 'allows cancellation when the card is not in redeemed status' do
        card.status = :canceled
        expect(card).to be_valid
      end

      it 'does not allow cancellation if the previous status is redeemed' do
        card.update_columns(status: :redeemed)
        card.status = :canceled
        expect(card).not_to be_valid
      end

      it 'create error messsage if the previous status is redeemed' do
        card.update_columns(status: :redeemed)
        card.status = :canceled
        card.valid?
        expect(card.errors[:status]).to include('can not be canceled')
      end
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:status) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'callbacks' do
    context 'when prepare to validate' do
      let(:card) { create(:card, activation_number: nil, pin_number: nil) }

      it 'generate activation number if missing' do
        expect(card.activation_number).to be_truthy
      end

      it 'generate pin number if missing' do
        expect(card.pin_number).to be_truthy
      end
    end
  end
end
