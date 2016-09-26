class Playlist < ActiveRecord::Base
  belongs_to :radiostations

  require 'nokogiri'
  require 'open-uri'
  require 'date'

  def self.veronica

    url = "http://www.radioveronica.nl/gemist/playlist"
    doc = Nokogiri::HTML(open(url))
    @last_image = doc.xpath("//img[@class='playlistimg']/@src")[0].value
    @last_time = doc.xpath("//tr[@class='active']//td[2]").text
    @last_artist = doc.xpath("//tr[@class='active']//td[3]").text
    @last_title = doc.xpath("//tr[@class='active']//td[4]").text
    @last_fullname = "#{@last_artist} #{@last_title}"
    @second_last_image = doc.xpath("//img[@class='playlistimg']/@src")[1].value
    @second_last_time = doc.xpath("//tr[2]//td[2]").text
    @second_last_artist = doc.xpath("//tr[2]//td[3]").text
    @second_last_title = doc.xpath("//tr[2]//td[4]").text
    @second_last_fullname = "#{@second_last_artist} #{@second_last_title}"
    @third_last_image = doc.xpath("//img[@class='playlistimg']/@src")[2].value
    @third_last_time = doc.xpath("//tr[3]//td[2]").text
    @third_last_artist = doc.xpath("//tr[3]//td[3]").text
    @third_last_title = doc.xpath("//tr[3]//td[4]").text
    @third_last_fullname = "#{@third_last_artist} #{@third_last_title}"

    Playlist.last_played
    Playlist.second_last_played
    Playlist.third_last_played

  end

  def self.last_played

    if (Time.zone.now.strftime("%H").to_i == 00) && (@last_time[0..-4].to_i == 23)
      @date = Date.yesterday
      @date.strftime("%d %B %Y")
    else
      @date = Time.zone.now.strftime("%d %B %Y")
    end

    if (Playlist.order(updated_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @last_fullname }) || (Playlist.order(created_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @last_fullname })
      puts "#{@last_fullname} in last 3 songs"
    else
      if Playlist.where(fullname: @last_fullname).exists?
        playlist = Playlist.find_by_fullname(@last_fullname)
        playlist.image = @last_image
        playlist.time = @last_time
        playlist.date = @date
        playlist.day_counter += 1
        playlist.week_counter += 1
        playlist.month_counter += 1
        playlist.year_counter += 1
        playlist.total_counter += 1
        playlist.save
        puts "#{@last_fullname} + 1"
      else
        playlist = Playlist.new
        playlist.image = @last_image
        playlist.time = @last_time
        playlist.date = @date
        playlist.artist = @last_artist
        playlist.title = @last_title
        playlist.fullname = @last_fullname
        playlist.day_counter = 1
        playlist.week_counter = 1
        playlist.month_counter = 1
        playlist.year_counter = 1
        playlist.total_counter = 1
        playlist.save
        puts "#{@last_fullname} added to the database"
      end
    end
  end

  def self.second_last_played

    if (Time.zone.now.strftime("%H").to_i == 00) && (@second_last_time[0..-4].to_i == "23")
      @date = Date.yesterday
      @date.strftime("%d %B %Y")
    else
      @date = Time.zone.now.strftime("%d %B %Y")
    end

    if Playlist.order(updated_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @second_last_fullname } || (Playlist.order(created_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @second_last_fullname })
      puts "#{@second_last_fullname} in last 3 songs"
    else
      if Playlist.where(fullname: @second_last_fullname).exists?
        playlist = Playlist.find_by_fullname(@second_last_fullname)
        playlist.image = @second_last_image
        playlist.time = @second_last_time
        playlist.date = @date
        playlist.day_counter += 1
        playlist.week_counter += 1
        playlist.month_counter += 1
        playlist.year_counter += 1
        playlist.total_counter += 1
        playlist.save
        puts "#{@second_last_fullname} + 1"
      else
        playlist = Playlist.new
        playlist.image = @second_last_image
        playlist.time = @second_last_time
        playlist.date = @date
        playlist.artist = @second_last_artist
        playlist.title = @second_last_title
        playlist.fullname = @second_last_fullname
        playlist.day_counter = 1
        playlist.week_counter = 1
        playlist.month_counter = 1
        playlist.year_counter = 1
        playlist.total_counter = 1
        playlist.save
        puts "#{@second_last_fullname} added to the database"
      end
    end
  end

  def self.third_last_played

    if (Time.zone.now.strftime("%H").to_i == 00) && (@thrid_last_time[0..-4].to_i == 23)
      @date = Date.yesterday
      @date.strftime("%d %B %Y")
    else
      @date = Time.zone.now.strftime("%d %B %Y")
    end

    if Playlist.order(updated_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @third_last_fullname } || (Playlist.order(created_at: :desc).limit(6).any?{ |playlist| playlist.fullname == @third_last_fullname })
      puts "#{@third_last_fullname} in last 3 songs"
    else
      if Playlist.where(fullname: @third_last_fullname).exists?
        playlist = Playlist.find_by_fullname(@third_last_fullname)
        playlist.image = @third_last_image
        playlist.time = @third_last_time
        playlist.date = @date
        playlist.day_counter += 1
        playlist.week_counter += 1
        playlist.month_counter += 1
        playlist.year_counter += 1
        playlist.total_counter += 1
        playlist.save
        puts "#{@third_last_fullname} + 1"
      else
        playlist = Playlist.new
        playlist.image = @third_last_image
        playlist.time = @third_last_time
        playlist.date = @date
        playlist.artist = @third_last_artist
        playlist.title = @third_last_title
        playlist.fullname = @third_last_fullname
        playlist.day_counter = 1
        playlist.week_counter = 1
        playlist.month_counter = 1
        playlist.year_counter = 1
        playlist.total_counter = 1
        playlist.save
        puts "#{@third_last_fullname} added to the database"
      end
    end
  end

  def self.reset_day_counters
    songs = Playlist.all
    songs.each do |song|
      song.day_counter = 0
      song.save
    end
  end

  def self.reset_week_counters
    today = Date.today
    if today.sunday?
      songs = Playlist.all
      songs.each do |song|
        song.week_counter = 0
        song.save
      end
    end
  end

  def self.reset_month_counters
    today = Date.today
    if today == Date.today.end_of_month
      songs = Playlist.all
      songs.each do |song|
        song.month_counter = 0
        song.save
      end
    end
  end

  def self.reset_year_counters
    today = Date.today
    if today == Date.today.end_of_year
      songs = Playlist.all
      songs.each do |song|
        song.year_counter = 0
        song.save
      end
    end
  end

end
