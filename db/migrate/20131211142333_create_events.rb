class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :start
      t.string :end
      t.string :content

      t.timestamps
    end
  end
end
