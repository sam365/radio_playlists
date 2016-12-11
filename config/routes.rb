Rails.application.routes.draw do

  resources :playlists do
    collection {
      get :autocomplete
      get :sort_today
      get :sort_week
      get :sort_month
      get :sort_year
      get :sort_total
      get :sort_created
      get :sort_updated
    }
  end

  resources :radio2playlists do
    collection {
      get :autocomplete
      get :sort_today
      get :sort_week
      get :sort_month
      get :sort_year
      get :sort_total
      get :sort_created
      get :sort_updated
    }
  end

  resources :radio538playlists do
    collection {
      get :autocomplete
      get :sort_today
      get :sort_week
      get :sort_month
      get :sort_year
      get :sort_total
      get :sort_created
      get :sort_updated
    }
  end

  resources :sublimefmplaylists do
    collection {
      get :autocomplete
      get :sort_today
      get :sort_week
      get :sort_month
      get :sort_year
      get :sort_total
      get :sort_created
      get :sort_updated
    }
  end

  resources :grootnieuwsplaylists do
    collection {
      get :autocomplete
      get :sort_today
      get :sort_week
      get :sort_month
      get :sort_year
      get :sort_total
      get :sort_created
      get :sort_updated
    }
  end

  resources :generalplaylists do
    collection {
      get :today_played_songs
      get :top_songs
      get :top_artists
      get :autocomplete
      get :song_details
    }
  end

  root 'generalplaylists#index'

end
