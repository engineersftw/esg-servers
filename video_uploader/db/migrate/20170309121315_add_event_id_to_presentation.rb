class AddEventIdToPresentation < ActiveRecord::Migration[5.0]
  def change
    add_column :presentations, :event_id, :integer, index: true
  end
end
