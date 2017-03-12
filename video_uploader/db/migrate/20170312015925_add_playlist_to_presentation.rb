class AddPlaylistToPresentation < ActiveRecord::Migration[5.0]
  def change
    add_column :presentations, :playlist_id, :integer, index: true, unique: true
  end
end
