class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.jsonb :notes, default: {}
      t.references :trackable, type: :uuid, polymorphic: true
      t.timestamps
    end
  end
end
