class AddTrackUrlToShows < ActiveRecord::Migration
  def change
    add_column :shows, :track_url, :string
  end
end
