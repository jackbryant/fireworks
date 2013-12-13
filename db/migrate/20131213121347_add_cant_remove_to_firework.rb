class AddCantRemoveToFirework < ActiveRecord::Migration
  def change
    add_column :fireworks, :cant_remove, :boolean
  end
end
