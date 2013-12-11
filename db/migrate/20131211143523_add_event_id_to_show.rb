class AddEventIdToShow < ActiveRecord::Migration
  def change
    add_column :shows, :event_id, :integer
  end
end
