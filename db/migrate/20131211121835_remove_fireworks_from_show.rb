class RemoveFireworksFromShow < ActiveRecord::Migration
  def up
    remove_column :shows, :firework_id
  end

  def down
    add_column :shows, :firework_id, :integer
  end
end
