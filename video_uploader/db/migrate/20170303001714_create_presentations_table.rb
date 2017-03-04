class CreatePresentationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :presentations do |t|
      t.string :title, null: true
      t.text :description, null: true
      t.string :foreign_uid, null: true
      t.string :source, null: true
      t.date :presented_at, null: true
      t.string :status, null: false, default: 'pending'
      t.boolean :active, default: true, index: true
    end

    add_index(:presentations, [:foreign_uid, :source])
  end
end
