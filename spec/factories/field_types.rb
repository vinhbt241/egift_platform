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
FactoryBot.define do
  factory :field_type do
    name { 'integer' }
  end
end
