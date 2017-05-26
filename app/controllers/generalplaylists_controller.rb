class GeneralplaylistsController < ApplicationController

  def index
  # Playlist search options
    if params[:search_playlists].present? && params[:radiostation_id].present? && params[:set_counter_playlists].present?
      case params[:set_counter_playlists]
        when "day"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").where("generalplaylists.created_at > ?", Date.today.beginning_of_day).limit(params[:set_limit_playlists])
        when "week"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").where("generalplaylists.created_at > ?", Date.today.beginning_of_week).limit(params[:set_limit_playlists])
        when "month"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").where("generalplaylists.created_at > ?", Date.today.beginning_of_month).limit(params[:set_limit_playlists])
        when "year"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").where("generalplaylists.created_at > ?", Date.today.beginning_of_year).limit(params[:set_limit_playlists])
        when "total"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").limit(params[:set_limit_playlists])
      end

    elsif params[:search_playlists].present? && params[:radiostation_id].present?
      @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.title ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("radiostation_id = ?", "#{params[:radiostation_id]}").limit(params[:set_limit_playlists])

    elsif params[:search_playlists].present? && params[:set_counter_playlists].present?
      case params[:set_counter_playlists]
        when "day"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("generalplaylists.created_at > ?", Date.today.beginning_of_day).limit(params[:set_limit_playlists])
        when "week"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("generalplaylists.created_at > ?", Date.today.beginning_of_week).limit(params[:set_limit_playlists])
        when "month"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("generalplaylists.created_at > ?", Date.today.beginning_of_month).limit(params[:set_limit_playlists])
        when "year"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").where("generalplaylists.created_at > ?", Date.today.beginning_of_year).limit(params[:set_limit_playlists])
        when "total"
          @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%")
      end

    elsif params[:radiostation_id].present? && params[:set_counter_playlists].present?
      case params[:set_counter_playlists]
        when "day"
          @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}").where("created_at > ?", Date.today.beginning_of_day).limit(params[:set_limit_playlists])
        when "week"
          @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}").where("created_at > ?", Date.today.beginning_of_week).limit(params[:set_limit_playlists])
        when "month"
          @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}").where("created_at > ?", Date.today.beginning_of_month).limit(params[:set_limit_playlists])
        when "year"
          @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}").where("created_at > ?", Date.today.beginning_of_year).limit(params[:set_limit_playlists])
        when "total"
          @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}")
      end

    elsif params[:search_playlists].present?
      @playlists = Generalplaylist.joins(:artist, :song).where("artists.name ILIKE ? OR songs.fullname ILIKE ?", "%#{params[:search_playlists]}%", "%#{params[:search_playlists]}%").limit(params[:set_limit_playlists])

    elsif params[:radiostation_id].present?
      @playlists = Generalplaylist.where("radiostation_id = ?", "#{params[:radiostation_id]}").limit(params[:set_limit_playlists])

    elsif params[:set_counter_playlists].present?
      case params[:set_counter_playlists]
        when "day"
          @playlists = Generalplaylist.where("created_at > ?", Date.today.beginning_of_day).limit(params[:set_limit_playlists])
        when "week"
          @playlists = Generalplaylist.where("created_at > ?", Date.today.beginning_of_week).limit(params[:set_limit_playlists])
        when "month"
          @playlists = Generalplaylist.where("created_at > ?", Date.today.beginning_of_month).limit(params[:set_limit_playlists])
        when "year"
          @playlists = Generalplaylist.where("created_at > ?", Date.today.beginning_of_year).limit(params[:set_limit_playlists])
        when "total"
          @playlists = Generalplaylist.all.limit(params[:set_limit_playlists])
      end

    else
      if params[:set_limit_playlists].present?
        @playlists = Generalplaylist.order(created_at: :DESC).limit(params[:set_limit_playlists])
      else
        @playlists = Generalplaylist.order(created_at: :DESC).limit(5)
      end
    end

    @playlists.order!(created_at: :DESC)

  # Song search options
    if params[:search_top_song].present? && params[:radiostation_id].present? && params[:set_counter_top_songs].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      case params[:set_counter_top_songs]
        when "day"
          @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ? AND generalplaylists.created_at > ? AND songs.fullname ILIKE ?", params[:radiostation_id], Date.today.beginning_of_day, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "week"
          @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ? AND generalplaylists.created_at > ? AND song.fullname ILIKE ?", params[:radiostation_id], Date.today.beginning_of_week, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "month"
          @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ? AND generalplaylists.created_at > ? AND song.fullname ILIKE ?", params[:radiostation_id], Date.today.beginning_of_month, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "year"
          @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ? AND generalplaylists.created_at > ? AND song.fullname ILKE ?", params[:radiostation_id], Date.today.beginning_of_year, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "total"
          @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ?", params[:radiostation_id], "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      end

    elsif params[:search_top_song].present? && params[:radiostation_id].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      @songs_counter = Generalplaylist.joins(:song).where("radiostation_id = ? AND songs.fullname ILIKE ?", radiostation.id, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)

    elsif params[:search_top_song].present? && params[:set_counter_top_songs].present?
      case params[:set_counter_top_songs]
        when "day"
          @songs_counter = Generalplaylist.joins(:song).where("generalplaylists.created_at > ?", Date.today.beginning_of_day, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "week"
          @songs_counter = Generalplaylist.joins(:song).where("generalplaylists.created_at > ?", Date.today.beginning_of_week, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "month"
          @songs_counter = Generalplaylist.joins(:song).where("generalplaylists.created_at > ?", Date.today.beginning_of_month, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "year"
          @songs_counter = Generalplaylist.joins(:song).where("generalplaylists.created_at > ?", Date.today.beginning_of_year, "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "total"
          @songs_counter = Generalplaylist.joins(:song).where("songs.fullname ILIKE ?", "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      end

    elsif params[:radiostation_id].present? && params[:set_counter_top_songs].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      case params[:set_counter_top_songs]
      when "day"
        @songs_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_day).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      when "week"
        @songs_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_week).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      when "month"
        @songs_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_month).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      when "year"
        @songs_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_year).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      when "total"
        @songs_counter = Generalplaylist.where("radiostation_id = ?", params[:radiostation_id]).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      end

    elsif params[:search_top_song].present?
      @songs_counter = Generalplaylist.joins(:song).where("songs.fullname ILIKE ?", "%#{params[:search_top_song]}%").group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)

    elsif params[:radiostation_id].present?
      radiostation = Radiostation.find(params[:radiostation_id])
      @songs_counter = Generalplaylist.where("radiostation_id = ?", radiostation.id).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)

    elsif params[:set_counter_top_songs].present?
      case params[:set_counter_top_songs]
        when "day"
          @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_day).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "week"
          @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_week).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "month"
          @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_month).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "year"
          @songs_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_year).group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
        when "total"
          @songs_counter = Generalplaylist.group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      end

    else
      if params[:set_limit_songs].present?
        @songs_counter = Generalplaylist.group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(params[:set_limit_songs].to_i)
      else
        @songs_counter = Generalplaylist.group(:song_id).count.sort_by{|song_id, counter| counter}.reverse.take(5)
      end
    end


  # Artist search options
    if params[:search_top_artist].present? && params[:radiostation_id].present? && params[:set_counter_top_artists].present?
      case params[:set_counter_top_artists]
        when "day"
          @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND generalplaylists.created_at > ? AND artists.name ILIKE ?", params[:radiostation_id], Date.today.beginning_of_day, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "week"
          @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND generalplaylists.created_at > ? AND artists.name ILIKE ?", params[:radiostation_id], Date.today.beginning_of_week, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "month"
          @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND generalplaylists.created_at > ? AND artists.name ILIKE ?", params[:radiostation_id], Date.today.beginning_of_month, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "year"
          @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND generalplaylists.created_at > ? AND artists.name ILIKE ?", params[:radiostation_id], Date.today.beginning_of_year, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "total"
          @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND artists.name ILIKE ?", params[:radiostation_id], "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        end

    elsif params[:search_top_artist].present? && params[:radiostation_id].present?
      @artists_counter = Generalplaylist.joins(:artist).where("radiostation_id = ? AND artists.name ILIKE ?", params[:radiostation_id], "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)

    elsif params[:search_top_artist].present? && params[:set_counter_top_artists].present?
      case params[:set_counter_top_artists]
        when "day"
          @artists_counter = Generalplaylist.joins(:artist).where("generalplaylists.created_at > ? AND artists.name ILIKE ?", Date.today.beginning_of_day, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "week"
          @artists_counter = Generalplaylist.joins(:artist).where("generalplaylists.created_at > ? AND artists.name ILIKE ?", Date.today.beginning_of_week, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "month"
          @artists_counter = Generalplaylist.joins(:artist).where("generalplaylists.created_at > ? AND artists.name ILIKE ?", Date.today.beginning_of_month, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "year"
          @artists_counter = Generalplaylist.joins(:artist).where("generalplaylists.created_at > ? AND artists.name ILIKE ?", Date.today.beginning_of_year, "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "total"
          @artists_counter = Generalplaylist.joins(:artist).where("artists.name ILIKE ?", "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        end

    elsif params[:radiostation_id].present? && params[:set_counter_top_artists].present?
      case params[:set_counter_top_artists]
        when "day"
          @artists_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_day).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "week"
          @artists_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_week).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "month"
          @artists_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_month).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "year"
          @artists_counter = Generalplaylist.where("radiostation_id = ? AND created_at > ?", params[:radiostation_id], Date.today.beginning_of_year).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "total"
          @artists_counter = Generalplaylist.where("radiostation_id = ?", params[:radiostation_id]).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        end

    elsif params[:search_top_artist].present?
      @artists_counter = Generalplaylist.joins(:artist).where("artists.name ILIKE ?", "%#{params[:search_top_artist]}%").group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)

    elsif params[:radiostation_id].present?
      @artists_counter = Generalplaylist.where("radiostation_id = ?", radiostation.id).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)

    elsif params[:set_counter_top_artists].present?
      case params[:set_counter_top_artists]
        when "day"
          @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_day).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "week"
          @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_week).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "month"
          @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_month).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "year"
          @artists_counter = Generalplaylist.where("created_at > ?", Date.today.beginning_of_year).group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        when "total"
          @artists_counter = Generalplaylist.group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
        end
    else
      if params[:set_limit_artists].present?
        @artists_counter = Generalplaylist.group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(params[:set_limit_artists].to_i)
      else
        @artists_counter = Generalplaylist.group(:artist_id).count.sort_by{|artist_id, counter| counter}.reverse.take(5)
      end
    end

    @target = params[:target]
  end

  # def autocomplete
  #   @results = Song.order(:fullname).where("fullname ILIKE ?", "%#{params[:term]}%").limit(10)
  #   render json: @results.map(&:fullname)
  # end

end
