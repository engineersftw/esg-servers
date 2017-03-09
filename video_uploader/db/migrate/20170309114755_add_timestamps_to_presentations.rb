class AddTimestampsToPresentations < ActiveRecord::Migration[5.0]
  def change
    add_column(:presentations, :created_at, :datetime)
    add_column(:presentations, :updated_at, :datetime)
  end
end
