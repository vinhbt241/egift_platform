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
    it { is_expected.to validate_uniqueness_of(:pin_number).scoped_to(:activation_number) }
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
