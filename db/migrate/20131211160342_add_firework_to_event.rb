class AddFireworkToEvent < ActiveRecord::Migration
  def change
    add_column :events, :firework_id, :integer
  end
end
