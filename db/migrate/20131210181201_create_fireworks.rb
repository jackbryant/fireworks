class CreateFireworks < ActiveRecord::Migration
  def change
    create_table :fireworks do |t|
      t.string :name
      t.integer :duration
      t.integer :delay
      t.integer :colour

      t.timestamps
    end
  end
end
