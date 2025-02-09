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
require 'rails_helper'

RSpec.describe ProductAccess, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    context 'when validate with shoulda matchers' do
      subject { create(:product_access, product:, client:) }

      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }
      let(:brand) { create(:brand, user:) }
      let(:product) { create(:product, brand:) }

      it { is_expected.to validate_uniqueness_of(:product_id).scoped_to(:client_id).case_insensitive }
    end

    context 'when product or client is outside or user assign scope' do
      let(:first_user) { create(:user) }
      let(:second_user) { create(:user) }
      let(:client) { create(:client, user: first_user) }
      let(:brand) { create(:brand, user: second_user) }
      let(:product) { create(:product, brand:) }

      it 'fails validation' do
        product_access = described_class.new(product:, client:)
        expect(product_access).not_to be_valid
      end

      it 'contains an error message for client_id' do
        product_access = described_class.new(product:, client:)
        product_access.valid?
        expect(product_access.errors[:client_id]).to include('maybe outside of user scope')
      end

      it 'contains an error message for product_id' do
        product_access = described_class.new(product:, client:)
        product_access.valid?
        expect(product_access.errors[:product_id]).to include('maybe outside of user scope')
      end
    end
  end
end
