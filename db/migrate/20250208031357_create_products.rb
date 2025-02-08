class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products, default: 'gen_random_uuid()' do |t|
      t.integer :state, default: 0
      t.references :brand, type: :uuid, foreign_key: { to_table: :brands }
      t.references :user, type: :uuid, foreign_key: { to_table: :users }
      t.decimal :price, null: false, precision: 21, scale: 3
      t.string :currency, null: false, limit: 3
      t.timestamps
    end
  end
end
