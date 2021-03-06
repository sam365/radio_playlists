# frozen_string_literal: tru

class Spotify
  attr_accessor :artists, :title

  def initialize(artists: nil, title: nil)
    @artists = artists
    @title = title
  end

  def find_spotify_track
    search_term = split_artists
    spotify_search_results = spotify_search(search_term)
    single_album_tracks = filter_single_and_album_tracks(spotify_search_results)
    filtered_tracks = custom_album_rejector(single_album_tracks)
    filtered_tracks.max_by(&:popularity)
  end

  private

  def split_artists
    regex = Regexp.new(ENV['MULTIPLE_ARTIST_REGEX'], Regexp::IGNORECASE)
    @artists.match?(regex) ? @artists.downcase.split(regex).map(&:strip).join(' ') : @artists.downcase
  end

  def spotify_search(search_term)
    RSpotify::Track.search("#{search_term} #{@title}")
                   .sort_by(&:popularity)
                   .reverse
  end

  def filter_single_and_album_tracks(spotify_tracks_search)
    spotify_tracks_search.reject { |t| t.album.album_type == 'compilation' }
  end

  def custom_album_rejector(single_album_tracks)
    track_filters = ENV['TRACK_FILTERS'].split(',')
    single_album_tracks.reject { |t| (track_filters - t.artists.map(&:name).join.downcase.split).count < track_filters.count }
  end

  def single_over_albums(single_album_tracks)
    single_tracks(single_album_tracks) || album_tracks(single_album_tracks)
  end

  def single_tracks(single_album_tracks)
    single_album_tracks.select { |t| t.album.album_type == 'single' }
  end

  def album_tracks(single_album_tracks)
    single_album_tracks.select { |t| t.album.album_type == 'album' }
  end
end
