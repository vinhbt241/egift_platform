class CreateFields < ActiveRecord::Migration[7.2]
  def change
    create_table :fields, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :field_type, type: :uuid, foreign_key: { to_table: :field_types }
      t.references :field_customizable, type: :uuid, polymorphic: true
      t.text :data
      t.timestamps
    end
  end
end
