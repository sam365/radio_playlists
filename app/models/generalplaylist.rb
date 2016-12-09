class Generalplaylist < ActiveRecord::Base
  belongs_to :song
  belongs_to :radiostation
  belongs_to :artist

  require 'nokogiri'
  require 'open-uri'
  require 'date'

  def self.radio_veronica_check
    url = "http://playlist24.nl/radio-veronica-playlist/"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[1]').text.squish
    artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[2]/a').text
    title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[1]/a').text

    artist = Artist.find_or_create_by(name:artist)
    songs = Song.where("title = ?", title)
    Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: "Radio Veronica")

    Generalplaylist.create_generalplaylist(time, artist, @song, radiostation)
  end

  def self.radio_538_check
    url = "https://www.relisten.nl/playlists/538.html"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/h4/small').text
    artist = doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/p/a').text
    title = (doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/h4[@class="media-heading"]').text).split.reverse.drop(1).reverse.join(" ")

    artist = Artist.find_or_create_by(name: artist)
    songs = Song.where("title = ?", title)
    Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: "Radio 538")

    Generalplaylist.create_generalplaylist(time, artist, @song, radiostation)
  end

  def self.radio_2_check

    topsong = "TOPSONG: "
    hi = "HI: "
    nieuwe_naam = "NIEUW NAAM: "

    url = "http://www.nporadio2.nl/playlist"
    doc = Nokogiri::HTML(open(url))
    list = doc.at('.columns-2')
    time = list.xpath('//li[last()]/a/div[3]/div/p').first.text
    artist = list.xpath('//li[last()]/a/div[2]/div/p[1]').first.text
    title = list.xpath('//li[last()]/a/div[2]/div/p[2]').first.text

    if title.include?(topsong)
      title.slice!(topsong)
    elsif title.include?(hi)
      title.slice!(hi)
    elsif title.include?(nieuwe_naam)
      title.slice!(nieuwe_naam)
    end

    artist = Artist.find_or_create_by(name: artist)
    songs = Song.where("title = ?", title)
    Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: "Radio 2")

    Generalplaylist.create_generalplaylist(time, artist, @song, radiostation)
  end

  def self.sublime_fm_check
    url = "http://playlist24.nl/sublime-fm-playlist/"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[1]').text.squish
    artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[2]/a').text
    title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[1]/a').text

    artist = Artist.find_or_create_by(name: artist)
    songs = Song.where("title = ?", title)
    Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: "Sublime FM")

    Generalplaylist.create_generalplaylist(time, artist, @song, radiostation)
  end

  def self.grootnieuws_radio_check
    url = "https://www.grootnieuwsradio.nl/muziek/playlist"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[1]').text.split.drop(1).join(" ")
    artist = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[2]').text
    title = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[3]').text

    artist = Artist.find_or_create_by(name: artist)
    songs = Song.where("title = ?", title)
    Generalplaylist.song_check(songs, artist, title)
    radiostation = Radiostation.find_or_create_by(name: "Groot Nieuws Radio")

    Generalplaylist.create_generalplaylist(time, artist, @song, radiostation)
  end

  def self.song_check(songs, artist, title)
    if songs == []
      @song = Song.find_or_create_by(title: title, artist: artist)
    else
      songs.each do |s|
        artist_name = s.artist.name
        check_artist = Artist.where("name = ?", artist_name)
        if check_artist == []
          @song = Song.find_or_create_by(title: title, artist: artist)
        else
          @song = Song.find_by_title_and_artist_id(title, artist.id)
        end
      end
    end
    return @song
  end

  def self.create_generalplaylist(time, artist, song, radiostation)
    radiostationsongs = Generalplaylist.where("radiostation_id = ? AND created_at > ?", radiostation.id, 2.day.ago)
    if radiostationsongs == []
      Generalplaylist.add_song(time, artist, song, radiostation)
    else
      if (radiostationsongs.last.time == time) && (radiostationsongs.last.song_id == song.id) && (radiostationsongs.last.artist_id == artist.id)
        puts "#{song.title} from #{artist.name} in last 3 songs on #{radiostation.name}"
        return false
      else
        Generalplaylist.add_song(time, artist, song, radiostation)
      end
    end
  end

  def self.add_song(time, artist, song, radiostation)

    generalplaylist = Generalplaylist.new
    generalplaylist.time = time
    generalplaylist.artist_id = artist.id
    generalplaylist.song_id = song.id
    generalplaylist.radiostation_id = radiostation.id
    generalplaylist.save!
    fullname = "#{artist.name} #{song.title}"
    songdetails = Song.find(generalplaylist.song_id)
    songdetails.day_counter += 1
    songdetails.week_counter += 1
    songdetails.month_counter += 1
    songdetails.year_counter += 1
    songdetails.total_counter += 1
    songdetails.fullname = fullname
    songdetails.artist_id = artist.id
    songdetails.save!
    artist = Artist.find(generalplaylist.artist_id)
    artist.day_counter += 1
    artist.week_counter += 1
    artist.month_counter += 1
    artist.year_counter += 1
    artist.total_counter += 1
    artist.save!
    puts "Saved #{song.title} from #{artist.name} on #{radiostation.name}!"
  end

  def self.reset_counters
    songs = Song.all
    today = Date.today
    song.each do |song|
      song.day_counter = 0
      song.save
    end
    if today.sunday?
      song.each do |song|
        song.week_counter = 0
        song.save
      end
    end
    if today == Date.today.end_of_month
      song.each do |song|
        song.month_counter = 0
        song.save
      end
    end
    if today == Date.today.end_of_year
      song.each do |song|
        song.year_counter
        song.save
      end
    end
  end

  def self.today_played_songs
    where("created_at > ?", 1.day.ago).order(created_at: :DESC)
  end

  def self.top_songs
    Song.all.order(total_counter: :DESC)
  end

  def autocomplete
    autocomplete.try(:fullname)
  end

  def autocomplete=(fullname)
    self.autocomplete = Song.find_by_fullname(fullname, include: :id) if fullname.present?
  end

  def self.destroy_all
    generalplaylists = Generalplaylist.all
    generalplaylists.each do |generalplaylist|
      generalplaylist.destroy
    end
  end

end
