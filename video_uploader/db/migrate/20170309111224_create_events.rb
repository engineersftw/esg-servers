class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title, null: true
      t.text :description, null: true
      t.string :foreign_uid, null: true
      t.string :source, null: true
      t.date :event_date
      t.string :status, null: false, default: 'pending'
      t.boolean :active, default: true, index: true

      t.timestamps
    end

    add_index(:events, [:foreign_uid, :source])
  end
end
