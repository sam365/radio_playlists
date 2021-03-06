# frozen_string_literal: true

class Song < ActiveRecord::Base
  has_many :artists_songs
  has_many :artists, through: :artists_songs
  has_many :generalplaylists
  has_many :radiostations, through: :generalplaylists

  MULTIPLE_ARTIST_REGEX = ';|\bfeat\.|\bvs\.|\bft\.|\bft\b|\bfeat\b|\bft\b|&|\bvs\b|\bversus|\band\b|\bmet\b|\b,|\ben\b|\/'
  TRACK_FILTERS = ['karoke', 'cover', 'made famous', 'tribute', 'backing business', 'arcade', 'instrumental', '8-bit', '16-bit'].freeze
  public_constant :MULTIPLE_ARTIST_REGEX
  public_constant :TRACK_FILTERS

  def self.search_title(title)
    where('title ILIKE ?', "%#{title}%")
  end

  def self.search(params)
    start_time = params[:start_time].present? ? Time.zone.strptime(params[:start_time], '%Y-%m-%dT%R') : 1.week.ago
    end_time = params[:end_time].present? ? Time.zone.strptime(params[:end_time], '%Y-%m-%dT%R') : Time.zone.now

    songs = Generalplaylist.joins(:song, :artists).all
    songs.where!('songs.title ILIKE ? OR artists.name ILIKE ?', "%#{params[:search_term]}%", "%#{params[:search_term]}%") if params[:search_term].present?
    songs.where!('radiostation_id = ?', params[:radiostation_id]) if params[:radiostation_id].present?
    songs.where!('generalplaylists.created_at > ?', start_time)
    songs.where!('generalplaylists.created_at < ?', end_time)
    songs.distinct
  end

  def self.group_and_count(songs)
    songs.group(:song_id).count.sort_by { |_song_id, counter| counter }.reverse
  end

  def self.spotify_track_to_song(spotify_track)
    song = Song.find_or_initialize_by(id_on_spotify: spotify_track.id)
    song.assign_attributes(
      title: spotify_track.name,
      spotify_song_url: spotify_track.external_urls['spotify'],
      spotify_artwork_url: spotify_track.album.images[0]['url']
    )
    song.save
    song
  end

  def cleanup
    destroy if generalplaylists.blank?
    artists.each(&:cleanup)
  end

  def self.find_and_remove_absolute_songs
    Song.all.each do |song|
      songs = find_same_songs(song)
      correct_song = songs.last
      next if songs.count <= 1 || correct_song.blank?

      remove_absolute_songs(songs, correct_song)
    end
  end

  private

  def find_same_songs(song)
    artist_ids = song.artists.map(&:id)
    Song.joins(:artists).where(artists: { id: artist_ids }).where('lower(title) = ?', song.title.downcase)
  end

  def remove_absolute_songs(songs, correct_song)
    songs.map(&:id).each do |id|
      next if id == correct_song.id

      absolute_song = Song.find(id) rescue next
      gps = Generalplaylist.where(song: absolute_song)
      gps.each { |gp| gp.update_attribute('song_id', correct_song.id) }
      absolute_song.cleanup
    end
  end
end
