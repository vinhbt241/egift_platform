# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
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
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:currency) }

    context 'when currency is invalid and price is blank' do
      let(:product) { build(:product, price: nil, currency: 'invalid') }

      it 'fail at validation step' do
        expect(product).not_to be_valid
      end

      it 'include message about invalid currency' do
        product.valid?
        expect(product.errors[:currency]).to be_truthy
      end
    end

    context 'when currency is invalid and price is present' do
      let(:product) { build(:product, currency: 'invalid') }

      it 'raise Money::Currency::UnknownCurrency' do
        expect { product.valid? }.to raise_error(Money::Currency::UnknownCurrency)
      end
    end
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:state) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:brand) }
    it { is_expected.to have_many(:fields) }
  end
end
