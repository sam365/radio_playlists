class GeneralplaylistsController < ApplicationController

  def index
    @generalplaylists = Generalplaylist.order(created_at: :desc).limit(10)
    @veronicaplaylists = Generalplaylist.where(radiostation_id: '1').order(created_at: :desc).limit(10)
    @radio538playlists = Generalplaylist.where(radiostation_id: '2').order(created_at: :desc).limit(10)
    @sublimefmplaylists = Generalplaylist.where(radiostation_id: '3').order(created_at: :desc).limit(10)
    @radio2playlists = Generalplaylist.where(radiostation_id: '4').order(created_at: :desc).limit(10)
    @gnrplaylists = Generalplaylist.where(radiostation_id: '5').order(created_at: :desc).limit(10)
    @top5songsweek = Song.order(week_counter: :desc).limit(10)
    @counter = 0
  end

  def song_details
    @details = Song.where("fullname ILIKE ?", "%#{params[:search_fullname]}%")
    @details.each do |detail|
      @generalplaylist = Generalplaylist.where("song_id = ?", detail.id)
    end
  end

  def today_played_songs
    @todayplayedsongs = Generalplaylist.today_played_songs.paginate(page: params[:page]).per_page(8)
  end

  def top_songs
    @topsongs = Generalplaylist.top_songs.paginate(page: params[:page]).per_page(8)
    @counter = 0
  end

  def autocomplete
    @results = Song.order(:fullname).where("fullname ILIKE ?", "%#{params[:term]}%").limit(10)
    render json: @results.map(&:fullname)
  end

end
