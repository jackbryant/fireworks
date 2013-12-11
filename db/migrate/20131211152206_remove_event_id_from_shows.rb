class RemoveEventIdFromShows < ActiveRecord::Migration
 def up
   remove_column :shows, :event_id
 end

 def down
   add_column :shows, :event_id, :integer
 end
end
