class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.string :title, null: false
      t.string :playlist_uid, null: true
      t.string :playlist_source, null: true, default: 'youtube'
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index(:playlists, [:playlist_uid, :playlist_source])
  end
end
