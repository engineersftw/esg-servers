class AddFieldsToPresentations < ActiveRecord::Migration[5.0]
  def change
    add_column :presentations, :uploaded_file, :string, null: true, index: true
    add_column :presentations, :video_id, :string, null: true, index: true
    add_column :presentations, :video_source, :string, default: 'youtube', index: true
  end
end
