class AddIndexGeneralPlaylists < ActiveRecord::Migration[6.0]
  def up
    add_column :generalplaylists, :broadcast_timestamp, :datetime

    Generalplaylist.find_in_batches do |group|
      group.each do |playlist|
        next if playlist.broadcast_timestamp.present?

        time_stamp = Time.parse(playlist.created_at.strftime('%F') + ' ' + playlist.time) rescue playlist.created_at
        playlist.update(broadcast_timestamp: time_stamp)
      end
    end

    remove_column :generalplaylists, :time, :string
    add_index :generalplaylists, [:song_id, :radiostation_id, :broadcast_timestamp], unique: true, name: 'playlist_radio_song_time'
  end

  def down
    remove_index :generalplaylists, [:song_id, :radiostation_id, :broadcast_timestamp]
    add_column :generalplaylists, :time, :string

    Generalplaylist.find_in_batches do |group|
      group.each do |playlist|
        next if playlist.time.present?

        playlist.update(time: playlist.created_at.strftime('%H:%M'))
      end
    end

    remove_column :generalplaylists, :broadcast_timestamp, :datetime
  end
end
