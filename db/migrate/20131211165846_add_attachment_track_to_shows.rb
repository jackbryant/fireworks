class AddAttachmentTrackToShows < ActiveRecord::Migration
  def self.up
    change_table :shows do |t|
      t.attachment :track
    end
  end

  def self.down
    drop_attached_file :shows, :track
  end
end
