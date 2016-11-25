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
    song = Song.find_or_create_by(title: title)
    radiostation = Radiostation.find_or_create_by(name: "Radio Veronica")

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.radio_538_check
    url = "https://www.relisten.nl/playlists/538.html"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/h4/small').text
    artist = doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/p/a').text
    title = (doc.xpath('//*[@id="playlist"]/div[1]/ul/li[1]/div/h4[@class="media-heading"]').text).split.reverse.drop(1).reverse.join(" ")

    artist = Artist.find_or_create_by(name: artist)
    song = Song.find_or_create_by(title: title)
    radiostation = Radiostation.find_or_create_by(name: "Radio 538")

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.radio_2_check
    url = "http://www.nporadio2.nl/playlist"
    doc = Nokogiri::HTML(open(url))
    list = doc.at('.columns-2')
    time = list.xpath('//li[last()]/a/div[3]/div/p').first.text
    artist = list.xpath('//li[last()]/a/div[2]/div/p[1]').first.text
    title = list.xpath('//li[last()]/a/div[2]/div/p[2]').first.text

    artist = Artist.find_or_create_by(name: artist)
    song = Song.find_or_create_by(title: title)
    radiostation = Radiostation.find_or_create_by(name: "Radio 2")

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.sublime_fm_check
    url = "http://playlist24.nl/sublime-fm-playlist/"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[1]').text.squish
    artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[2]/a').text
    title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[1]/a').text

    artist = Artist.find_or_create_by(name: artist)
    song = Song.find_or_create_by(title: title)
    radiostation = Radiostation.find_or_create_by(name: "Sublime FM")

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.grootnieuws_radio_check
    url = "https://www.grootnieuwsradio.nl/muziek/playlist"
    doc = Nokogiri::HTML(open(url))
    time = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[1]').text.split.drop(1).join(" ")
    artist = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[2]').text
    title = doc.xpath('//table[@id="iList1"]/tbody/tr[1]/td[3]').text

    artist = Artist.find_or_create_by(name: artist)
    song = Song.find_or_create_by(title: title)
    radiostation = Radiostation.find_or_create_by(name: "Groot Nieuws Radio")

    Generalplaylist.create_generalplaylist(time, artist, song, radiostation)
  end

  def self.create_generalplaylist(time, artist, song, radiostation)
    if Generalplaylist.order(updated_at: :desc).limit(100).any?{ |generalplaylist| (generalplaylist.radiostation_id == radiostation.id) && (generalplaylist.song_id == song.id) }
      puts "#{song.title} from #{artist.name} in last 3 songs on #{radiostation.name}"
      return false
    else
      generalplaylist = Generalplaylist.new
      generalplaylist.time = time
      generalplaylist.artist_id = artist.id
      generalplaylist.song_id = song.id
      generalplaylist.radiostation_id = radiostation.id
      generalplaylist.save!
      song = Song.find(generalplaylist.song_id)
      song.day_counter += 1
      song.week_counter += 1
      song.month_counter += 1
      song.year_counter += 1
      song.total_counter += 1
      song.artist_id = artist.id
      song.save!
      artist = Artist.find(generalplaylist.artist_id)
      artist.day_counter += 1
      artist.week_counter += 1
      artist.month_counter += 1
      artist.year_counter += 1
      artist.total_counter += 1
      artist.save!
      puts "Saved #{song.title} from #{artist.name} on #{radiostation.name}!"
    end
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

  def self.destroy_all
    generalplaylists = Generalplaylist.all
    generalplaylists.each do |generalplaylist|
      generalplaylist.destroy
    end
  end

end
