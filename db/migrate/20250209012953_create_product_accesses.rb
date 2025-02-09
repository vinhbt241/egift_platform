class CreateProductAccesses < ActiveRecord::Migration[7.2]
  def change
    create_table :product_accesses, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :product, type: :uuid, foreign_key: { to_table: :products }
      t.references :client, type: :uuid, foreign_key: { to_table: :clients }
      t.timestamps
    end

    add_index :product_accesses, [:product_id, :client_id], unique: true
  end
end
