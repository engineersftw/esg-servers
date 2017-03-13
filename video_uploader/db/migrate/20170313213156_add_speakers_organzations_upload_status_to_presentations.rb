class AddSpeakersOrganzationsUploadStatusToPresentations < ActiveRecord::Migration[5.0]
  def change
    add_column :presentations, :presenters, :string, null: true
    add_column :presentations, :organizations, :string, null: true
    add_column :presentations, :upload_status, :string, index: true, null: true
  end
end
