class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :user, type: :uuid, foreign_key: { to_table: :users }
      t.decimal :payout_rate, precision: 5, scale: 2, default: 100.0
      t.string :name, null: false
      t.string :identifier, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :clients, [:name, :user_id], unique: true
    add_index :clients, [:identifier], unique: true
  end
end
