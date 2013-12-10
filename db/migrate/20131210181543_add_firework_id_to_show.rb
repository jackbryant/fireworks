class AddFireworkIdToShow < ActiveRecord::Migration
  def change
    add_column :shows, :firework_id, :integer
  end
end
