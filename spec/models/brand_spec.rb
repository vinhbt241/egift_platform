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
#
# Indexes
#
#  index_brands_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject { create(:brand) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:state) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:fields) }
  end
end
