class Playlist < ActiveRecord::Base
  belongs_to :radiostations

  require 'nokogiri'
  require 'open-uri'
  require 'date'

  validates_presence_of :artist, :title, :time

  def self.sort_today
    order(day_counter: :desc)
  end

  def self.sort_week
    order(week_counter: :desc)
  end

  def self.sort_month
    order(month_counter: :desc)
  end

  def self.sort_year
    order(year_counter: :desc)
  end

  def self.sort_total
    order(total_counter: :desc)
  end

  def self.sort_created
    order(created_at: :desc)
  end

  def self.sort_updated
    order(updated_at: :desc)
  end

  def self.veronica

    # Fetching the data from the website and assinging them to variables
    url = "http://playlist24.nl/radio-veronica-playlist/"
    doc = Nokogiri::HTML(open(url))
    @last_time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[1]').text.squish
    @last_artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[2]/a').text
    @last_title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[3]/div[2]/span[1]/a').text
    @last_fullname = "#{@last_artist} #{@last_title}"
    @second_last_time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[4]/div[1]').text.squish
    @second_last_artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[4]/div[2]/span[2]/a').text
    @second_last_title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[4]/div[2]/span[1]/a').text
    @second_last_fullname = "#{@second_last_artist} #{@second_last_title}"
    @third_last_time = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[5]/div[1]').text.squish
    @third_last_artist = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[5]/div[2]/span[2]/a').text
    @third_last_title = doc.xpath('/html/body/div[3]/div[2]/div[1]/div[5]/div[2]/span[1]/a').text
    @third_last_fullname = "#{@third_last_artist} #{@third_last_title}"

    # Methodes for checking songs
    Playlist.last_played
    Playlist.second_last_played
    Playlist.third_last_played

  end

  def self.last_played

    time = @last_time

    # Go to the methode for checking which date the song is played.
    Playlist.check_date(time)

    fullname = @last_fullname
    image = @last_image
    time = @last_time
    date = @date
    artist = @last_artist
    title = @last_title

    # Go to the methode for checking the song
    Playlist.song_check(fullname, image, time, date, artist, title)

  end

  def self.second_last_played

    time = @second_last_time

    # Go to the methode for checking which date the song is played.
    Playlist.check_date(time)

    fullname = @second_last_fullname
    image = @second_last_image
    time = @second_last_time
    date = @date
    artist = @second_last_artist
    title = @second_last_title

    # Go to the methode for checking the song
    Playlist.song_check(fullname, image, time, date, artist, title)

  end

  def self.third_last_played

    time = @third_last_time

    # Go to the methode for checking which date the song is played.
    Playlist.check_date(time)

    fullname = @third_last_fullname
    image = @third_last_image
    time = @third_last_time
    date = @date
    artist = @third_last_artist
    title = @third_last_title

    # Go to the methode for checking the song
    Playlist.song_check(fullname, image, time, date, artist, title)

  end

  def self.song_check(fullname, image, time, date, artist, title)

    # Check if the song hasn't been played lately. It checks the last 6 database records that have been updated or have been created.
    # If the fullname of the song matches a fullname of any of them it doesn't continue.
    if (Playlist.order(updated_at: :desc).limit(6).any?{ |playlist| playlist.fullname == fullname }) || (Playlist.order(created_at: :desc).limit(6).any?{ |playlist| playlist.fullname == fullname })
      puts "#{fullname} in last 3 songs"
    else
      # Checking if the song fullname is present in the database.
      # If the song is present it increments the counters by one.
      if Playlist.where(fullname: fullname).exists?
        @playlist = Playlist.find_by_fullname(fullname)
        @playlist.image = image
        @playlist.time = time
        @playlist.date = date
        @playlist.day_counter += 1
        @playlist.week_counter += 1
        @playlist.month_counter += 1
        @playlist.year_counter += 1
        @playlist.total_counter += 1
        @playlist.save
        puts "#{fullname} + 1"
      # If the song isn't present it creates a new record
      else
        @playlist = Playlist.new
        @playlist.image = image
        @playlist.time = time
        @playlist.date = date
        @playlist.artist = artist
        @playlist.title = title
        @playlist.fullname = fullname
        @playlist.day_counter = 1
        @playlist.week_counter = 1
        @playlist.month_counter = 1
        @playlist.year_counter = 1
        @playlist.total_counter = 1
        @playlist.save
        puts "#{fullname} added to the database"
      end
    end

  end

  # Methode for defining the date the song is played.
  # if the time in current time zone (Amsterdam) is past midnight and the played song
  # is played at 23h the date is set to yesterday.
  def self.check_date(time)
    if (Time.zone.now.strftime("%H").to_i == 0) && (time[0..-4].to_i == 23)
      @date = Date.yesterday
      @date.strftime("%d %B %Y")
    # if not the current date is set as the date the song is played
    else
      @date = Time.zone.now.strftime("%d %B %Y")
    end
  end

  def self.reset_counters
    songs = Playlist.all
    today = Date.today
    # Reset the day counter. Runs everyday at midnight.
    songs.each do |song|
      song.day_counter = 0
      song.save
    end
    # Reset the week counter. Runs Monday at midnight.
    if today.sunday?
      songs.each do |song|
        song.week_counter = 0
        song.save
      end
    end
    # Reset the month counter. Runs at the end of the month.
    if today == Date.today.end_of_month
      songs.each do |song|
        song.month_counter = 0
        song.save
      end
    end
    # Reset the year counter. Runs at the end of the year.
    if today == Date.today.end_of_year
      songs.each do |song|
        song.year_counter = 0
        song.save
      end
    end
  end

  def self.uniq_tracks_day
    where('day_counter > ?', 0).count
  end

  def self.uniq_tracks_week
    where('week_counter > ?', 0).count
  end

  def self.uniq_tracks_month
    where('month_counter > ?', 0).count
  end

  def self.uniq_tracks_year
    where('year_counter > ?', 0).count
  end

  # Methodes for autocomplete search function
  def search_fullname
    Playlist.try(:fullname)
  end

  def search_fullname=(fullname)
    self.search_fullname = Playlist.find_by_fullname(fullname) if fullname.present?
  end

end
