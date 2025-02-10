# frozen_string_literal: true

# == Schema Information
#
# Table name: brands
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  state      :integer          default("active")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_brands_on_name_and_user_id  (name,user_id) UNIQUE
#  index_brands_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject { create(:brand) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

    describe 'validates fields_within_limit' do
      let(:field_type) { create(:field_type) }
      let(:brand) { build(:brand) }

      before do
        fields_attributes = []
        6.times do |i|
          fields_attributes << { name: "number_#{i}", data: i.to_s, field_type_id: field_type.id }
        end
        brand.fields_attributes = fields_attributes
      end

      it 'is invalid' do
        expect(brand).not_to be_valid
      end

      it 'add error message' do
        brand.valid?
        expect(brand.errors[:fields]).to include(
          "exceeds the maximum limit of #{brand.field_limit} per #{brand.class.name}"
        )
      end
    end
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:state) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:fields) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to have_many(:card_activities) }
  end
end
