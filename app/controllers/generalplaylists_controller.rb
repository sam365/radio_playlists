class GeneralplaylistsController < ApplicationController

  def index

    # Song search options
    if params[:search_top_song].present?
      @top_songs = Song.joins(:artist).where("songs.fullname ILIKE ? OR artists.name ILIKE ?", "%#{params[:search_top_song]}%", "%#{params[:search_top_song]}%").limit(50)
    else
      @top_songs = Song.order(total_counter: :DESC).limit(5)
    end
    if params[:radiostation_id].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      @top_songs = @top_songs.joins(:radiostations).where!("radiostations.name = ?", radiostation.name).limit(50).uniq
      @songs_counter = Generalplaylist.where("radiostation_id = ?", params[:radiostation_id]).group(:song_id).count
    end
    @top_songs.order!(total_counter: :DESC)
    @songs_counter = Generalplaylist.group(:song_id).count
    if params[:set_counter_top_songs].present?
      case params[:set_counter_top_songs]
      when "day"
        @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_day).group(:song_id).count
        @top_songs.reorder!(day_counter: :DESC)
      when "week"
        @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_week).group(:song_id).count
        @top_songs.reorder!(week_counter: :DESC)
      when "month"
        @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_month).group(:song_id).count
        @top_songs.reorder!(month_counter: :DESC)
      when "year"
        @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_year).group(:song_id).count
        @top_songs.reorder!(year_counter: :DESC)
      when "total"
        @songs_counter = Generalplaylist.group(:song_id).count
        @top_songs.reorder!(total_counter: :DESC)
      end
    end

    # Artist search options
    if params[:search_top_artist].present?
      @top_artists = Artist.where("name ILIKE ?", "%#{params[:search_top_artist]}%").limit(50)
    else
      @top_artists = Artist.order(total_counter: :DESC).limit(5)
    end
    @top_artists.order!(total_counter: :DESC)
    @artists_counter = Generalplaylist.group(:artist_id).count
    if params[:radiostation_id].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      @top_artists = @top_artists.joins(:radiostations).where!("radiostations.name LIKE ?", radiostation.name).uniq
      @artists_counter = Generalplaylist.where("radiostation_id = ?", params[:radiostation_id]).group(:artist_id).count
    end
    if params[:set_counter_top_artists].present?
      case params[:set_counter_top_artists]
      when "day"
        @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_day).group(:artist_id).count
        @top_artists.reorder!(day_counter: :DESC)
      when "week"
        @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_week).group(:artist_id).count
        @top_artists.reorder!(week_counter: :DESC)
      when "month"
        @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_month).group(:artist_id).count
        @top_artists.reorder!(month_counter: :DESC)
      when "year"
        @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_year).group(:artist_id).count
        @top_artists.reorder!(year_counter: :DESC)
      when "total"
        @artists_counter = Generalplaylist.group(:artist_id).count
        @top_artists.reorder!(total_counter: :DESC)
      end
    end

    @target = params[:target]
  end

  # def autocomplete
  #   @results = Song.order(:fullname).where("fullname ILIKE ?", "%#{params[:term]}%").limit(10)
  #   render json: @results.map(&:fullname)
  # end

end
