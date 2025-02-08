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
class FieldSerializer < ApplicationSerializer
  identifier :id

  fields :name, :data

  association :field_type, blueprint: FieldTypeSerializer
end
