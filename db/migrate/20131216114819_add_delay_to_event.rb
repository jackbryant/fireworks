class AddDelayToEvent < ActiveRecord::Migration
  def change
    add_column :events, :delay, :integer
  end
end
