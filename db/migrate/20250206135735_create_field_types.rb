class CreateFieldTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :field_types, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :field_types, :name, unique: true
  end
end
