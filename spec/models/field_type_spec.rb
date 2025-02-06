# frozen_string_literal: true

# == Schema Information
#
# Table name: field_types
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_field_types_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe FieldType, type: :model do
  subject(:field_type) { create(:field_type) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
