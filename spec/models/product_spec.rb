# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :uuid             not null, primary key
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

    describe 'validates fields_within_limit' do
      let(:field_type) { create(:field_type) }
      let(:product) { build(:product) }

      before do
        fields_attributes = []
        6.times do |i|
          fields_attributes << { name: "number_#{i}", data: i.to_s, field_type_id: field_type.id }
        end
        product.fields_attributes = fields_attributes
      end

      it 'is invalid' do
        expect(product).not_to be_valid
      end

      it 'add error message' do
        product.valid?
        expect(product.errors[:fields]).to include(
          "exceeds the maximum limit of #{product.field_limit} per #{product.class.name}"
        )
      end
    end
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:state) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:brand) }
    it { is_expected.to have_many(:fields) }
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:card_activities) }
  end
end
