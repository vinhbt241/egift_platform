# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                      :uuid             not null, primary key
#  data                    :text
#  field_customizable_type :string
#  name                    :string           not null
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
FactoryBot.define do
  factory :field do
    name { '24' }
    association :field_type
  end
end
