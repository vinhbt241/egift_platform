class CreateBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :brands, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :state, default: 0
      t.string :name, null: false
      t.timestamps
    end

    add_index :brands, :name, unique: true
  end
end
