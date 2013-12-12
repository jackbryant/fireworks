class AddEditableToEvent < ActiveRecord::Migration
  def change
    add_column :events, :editable, :boolean
  end
end
