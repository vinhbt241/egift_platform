# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id          :uuid             not null, primary key
#  identifier  :string           not null
#  name        :string           not null
#  payout_rate :decimal(5, 2)    default(100.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_clients_on_identifier        (identifier) UNIQUE
#  index_clients_on_name_and_user_id  (name,user_id) UNIQUE
#  index_clients_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :client do
    name { Faker::Name.unique.name }

    association :user
  end
end
