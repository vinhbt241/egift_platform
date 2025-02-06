# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                      :uuid             not null, primary key
#  data                    :text
#  field_customizable_type :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  field_customizable_id   :uuid
#  field_type_id           :uuid
#
# Indexes
#
#  index_fields_on_field_customizable  (field_customizable_type,field_customizable_id)
#  index_fields_on_field_type_id       (field_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_type_id => field_types.id)
#
require 'rails_helper'

RSpec.describe Field, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:field_type) }
    it { is_expected.to belong_to(:field_customizable) }
  end

  describe 'validations' do
    let(:field_type) { create(:field_type, name: 'String') }
    let(:field_customizable) { create(:brand) }
    let(:field) { build(:field, field_type: field_type, field_customizable: field_customizable) }

    before do
      allow(field_customizable).to receive_messages(
        fields: class_double(described_class, count: field_count),
        field_limit: field_limit
      )
    end

    context 'when within field limit' do
      let(:field_count) { 2 }
      let(:field_limit) { 3 }

      it 'is valid' do
        expect(field).to be_valid
      end
    end

    context 'when exceeding field limit' do
      let(:field_count) { 4 }
      let(:field_limit) { 3 }

      it 'is not valid' do
        expect(field).not_to be_valid
      end

      it 'add validation error' do
        field.valid?
        expect(field.errors[:field_customizable]).to include("must be less than #{field_limit}")
      end
    end
  end
end
