class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :product, type: :uuid, foreign_key: { to_table: :products }
      t.references :client, type: :uuid, foreign_key: { to_table: :clients }
      t.integer :status, default: 0
      t.string :activation_number, null: false
      t.string :pin_number, null: false
      t.timestamps
    end

    add_index :cards, [:pin_number, :activation_number], unique: true
  end
end
