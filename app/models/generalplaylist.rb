# frozen_string_literal: true

class Generalplaylist < ActiveRecord::Base
  belongs_to :song
  belongs_to :radiostation
  belongs_to :artist

  require 'nokogiri'
  require 'open-uri'

  def self.check_song_radio_station(url, radio_station)
    doc = Nokogiri::HTML open(url)
    artist, songs, title, time = Generalplaylist.get_artist_songs_title_time(doc)
    return unless Generalplaylist.title_check(title)

    song = Generalplaylist.song_check(songs, artist, title)

    Generalplaylist.create_generalplaylist(time, artist, song, radio_station)
  end

  # Check the Radio Veronica song
  def self.radio_veronica_check
    url = 'https://playlist24.nl/radio-veronica-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Radio Veronica')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  # Check the Radio 538 song
  def self.radio_538_check
    url = 'https://playlist24.nl/radio-538-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Radio 538')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  # Check Radio 2 song
  def self.radio_2_check
    url = 'https://playlist24.nl/radio-2-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Radio 2')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  # Check Sublime FM songs
  def self.sublime_fm_check
    url = 'https://playlist24.nl/sublime-fm-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Sublime FM')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  # Check Groot Nieuws Radio songs
  def self.grootnieuws_radio_check
    url = 'https://www.grootnieuwsradio.nl/muziek/playlist'
    doc = Nokogiri::HTML open(url)
    time = doc.xpath('//*[@id="anchor-sticky"]/article/div/div/div[2]/div[1]/div[1]/span').text
    artist_name = doc.xpath('//*[@id="anchor-sticky"]/article/div/div/div[2]/div[1]/div[2]').text.split.map(&:capitalize).join(" ")
    title = doc.xpath('//*[@id="anchor-sticky"]/article/div/div/div[2]/div[1]/div[3]').text.split.map(&:capitalize).join(" ")
    return false if artist_name.blank?

    Generalplaylist.title_check(title)

    artist = Artist.find_or_create_by(name: artist_name)
    songs = Song.where(title: title)
    song = Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: 'Groot Nieuws Radio')

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.sky_radio_check
    url = 'https://playlist24.nl/skyradio-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Sky Radio')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  def self.radio_3fm_check
    url = 'https://playlist24.nl/3fm-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Radio 3FM')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  def self.q_music_check
    url = 'https://playlist24.nl/qmusic-playlist/'
    radio_station = Radiostation.find_or_create_by(name: 'Qmusic')

    Generalplaylist.check_song_radio_station(url, radio_station)
  end

  def self.title_check(title)
    # catch more then 4 digits, forward slashes, 2 single qoutes,
    # reklame/reclame, 2 dots and dash
    !title.match(/\d{4,}|\/|\'{2,}|(reklame|reclame)|\.{2,}|-/)
  end

  # Methode for checking if there are songs with the same title.
  # if so the artist id must be check
  # if the artist with the some song is not in the database the song with artist Id must be added
  def self.song_check(songs, artist, title)
    # If there is no song with the same title create a new one
    song = if songs.blank?
             Song.find_or_create_by(title: title, artist: artist)
           # If the is a song with the same title check the artist
           else
             songs.each do |s|
               artist_name = s.artist.name
               check_artist = Artist.where(name: artist_name)
               if check_artist.blank?
                 # If there is no song title with the same artist create a new one
                 Song.find_or_create_by(title: title, artist: artist)
               else
                 # Else grap the song record with the same title and artist id
                 Song.find_by(title: title, artist: artist)
               end
             end
           end

    song = song.first if song.is_a?(Array)
    song = Generalplaylist.find_spotify_links(song, artist, title)
    song
  end

  def self.find_spotify_links(song, artist, title)
    title = title.gsub(/\A\d{3}/, '').strip # opwekking songs
    # Spotify lookup image and song
    if RSpotify::Track.search("#{artist.name} #{title}").present?
      song.spotify_song_url = RSpotify::Track.search("#{artist.name} #{title}").first.external_urls["spotify"]
      song.spotify_artwork_url = @track_album = RSpotify::Track.search("#{artist.name} #{title}").first.album.images[1]["url"]
    end
    song
  end

  # Methode for creating the Generalplaylist record
  def self.create_generalplaylist(time, artist, song, radio_station)
    # Take all the songs that are played on the same radiostation the last 2 days
    radio_station_songs = Generalplaylist.where(radiostation: radio_station,
                                                created_at: 1.day.ago..Time.now)
                                         .order(id: :ASC)
    # If the is no song played the last 2 days create a new one
    if radio_station_songs.blank?
      Generalplaylist.add_song(time, artist, song, radio_station)
    # Else check if the last played song = the same as the song we want to check
    else
      @songs_recently_played = []
      radio_station_songs.each do |radio_station_song|
        if radio_station_song.time == time && radio_station_song.song == song && radio_station_song.artist == artist
          Rails.logger.info "#{song.title} from #{artist.name} in last songs on #{radio_station.name}"
          @songs_recently_played << true
        else
          @songs_recently_played << false
        end
      end
      if @songs_recently_played.exclude? true
        Generalplaylist.add_song(time, artist, song, radio_station)
      end
    end
  end

  # Methode for adding the song to the database
  def self.add_song(time, artist, song, radio_station)
    fullname = "#{artist.name} #{song.title}"
    # Create a new Generalplaylist record
    Generalplaylist.create(
      time: time,
      artist: artist,
      song: song,
      radiostation: radio_station
    )
    song.update(fullname: fullname, artist: artist)

    Rails.logger.info "Saved #{song.title} (#{song.id}) from #{artist.name} (#{artist.id}) on #{radio_station.name}!"
  end

  def self.check_all_radiostations
    radio_veronica_check
    radio_538_check
    radio_2_check
    radio_3fm_check
    sky_radio_check
    q_music_check
    sublime_fm_check
    grootnieuws_radio_check
  end

  # fetch the top 10 songs played from a radiostation
  def self.top_songs_radiostation(radiostation_id)
    # get all the songs played by the radiostation
    all_from_radiostation = Generalplaylist.where(radiostation_id: radiostation_id)
    # group all the by song_id and count all the time the song_id is in the list. Returns a hash
    top_songs_hash = all_from_radiostation.group(:song_id).count
    # Sort the hash by the value and reverse the order. Show only the first 10 results
    top_songs = top_songs_hash.sort_by { |_key, value| value }.reverse[0 .. 9]
    # resturn the array from song_id with counts
    top_songs
  end

  def self.top_artists_radiostation(radiostation_id)
    all_from_radiostation = Generalplaylist.where(radiostation_id: radiostation_id)
    top_artists_hash = all_from_radiostation.group(:artist_id).count
    top_artists = top_artists_hash.sort_by{ |_key, value| value }.reverse[0 .. 9]
    top_artists
  end

  def autocomplete
    autocomplete.try(:fullname)
  end

  def autocomplete=(fullname)
    self.autocomplete = Song.find_by_fullname(fullname, include: :id) if fullname.present?
  end

  def self.get_artist_songs_title_time(doc)
    time = doc.xpath('//html/body/div[3]/div[2]/div[1]/div[1]/div[3]/div[1]').text.strip
    artist_name = doc.xpath('//html/body/div[3]/div[2]/div[1]/div[1]/div[3]/div[2]/span[2]').text.strip
    title = doc.xpath('//html/body/div[3]/div[2]/div[1]/div[1]/div[3]/div[2]/span[1]').text.strip
 
    title = title.gsub(/\A(Hi:|Topsong:|Nieuwe Naam:)/, '').strip
    # Find the artist name in the Artist database or create a new record
    artist = Artist.find_or_create_by(name: artist_name)
    # Search for all the songs with title
    songs = Song.where(title: title)

    [artist, songs, title, time]
  end
end
