class DropDuplicatedColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :presentations, :source
    remove_column :presentations, :foreign_uid
  end
end
