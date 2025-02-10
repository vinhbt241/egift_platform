# frozen_string_literal: true

# seed data files are run in order
SEED_DATA_FILE = %w[
  user_seed
  field_type_seed
  brand_seed
  product_seed
  client_seed
].freeze

SEED_DATA_FILE.each do |seed_file|
  file = Rails.root.join("db/seeds/#{seed_file}.rb")
  load file
end
