<template>
  <div class='card mx-1 playlist-card'>
    <span v-if='loading'>
      <LoadingBar class='card-img-top' v-bind:height='"190px"' v-bind:width='"90%"' />
    </span>
    <span v-else-if='!!song'>
      <img :src='song.data.attributes.spotify_artwork_url' class='card-img-top' />
    </span>

    <div class='card-body'>
      <div class='d-flex flex-column'>
        <div class='d-flex d-flex-row'>
          <div class='rubik mr-2'>
            <div>{{ playedTime() }}</div>
            <div><small><i>{{ playedDate() }}</i></small></div>
          </div>
          <!-- Radio station label -->
          <div v-if='loading'>
            <LoadingBar />
          </div>
          <div v-else-if='!!radioStation' class='ml-auto'>
            <span class='badge badge-secondary'>{{ radioStation.data.attributes.name }}</span>
          </div>
        </div>
        <div class='my-2'>
          <!-- Song -->
          <div v-if='loading'>
            <LoadingBar />
          </div>
          <div v-else-if='!!song'>
            <span>{{ song.data.attributes.title }}</span>
          </div>
          <!-- Artist -->
          <div v-if='loading'>
            <LoadingBar />
          </div>
          <div v-else-if='!!artists'>
            <small><i>{{ artistName() }}</i></small>
          </div>
        </div>
        <div v-if='!!song && !!song.data.attributes.spotify_song_url' class='mt-2 d-flex flex-row'>
          <div class='ml-auto'>
            <img :src='spotifyLogo' class='spotify-btn' v-on:click='handleClickSpotifyBtn' />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import LoadingBar from '../application/loading_bar.vue'
  import SpotifyLogo from 'images/Spotify_Icon_RGB_Green.png'

  export default {
    props: ['item'],
    components: { LoadingBar },
    data () {
      return {
        artists: [],
        song: null,
        songArtworkUrl: null,
        radioStation: null,
        loading: true,
        spotifyLogo: SpotifyLogo
      }
    },
    methods: {
      handleClickSpotifyBtn() {
        window.open(this.song.data.attributes.spotify_song_url, '_blank')
      },
      playedTime() {
        const date = new Date(this.item.attributes.broadcast_timestamp)
        const hh = (date.getHours() < 10 ? '0' : '') + date.getHours()
        const mm = (date.getMinutes() < 10 ? '0' : '') + date.getMinutes()
        
        return hh + ':' + mm
      },
      playedDate() {
        const date = new Date(this.item.attributes.created_at)
        const dd = date.getDate()
        const mm = date.getMonth()+1
        const yyyy = date.getFullYear()

        return dd + '-' + mm + '-' + yyyy
      },
      getValue() {
        this.item
        const attributes = this.item.attributes
        const songUrl = '/songs/' + attributes.song_id
        const radioStationUrl = '/radiostations/' + attributes.radiostation_id
        const options = {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8'
          }
        }

        fetch(songUrl, options).then(res => res.json())
          .then(d => { 
            this.song = d
            this.loading = false

            for(let artist of this.song.data.relationships.artists.data) {
              const artistUrl = '/artists/' + artist.id
              fetch(artistUrl, options).then(res => res.json())
                .then(d => this.artists.push(d))
            }
          })

        fetch(radioStationUrl, options).then(res => res.json())
          .then(d => this.radioStation = d)
      },
      artistName() {
        return this.artists.map(artist => artist.data.attributes.name ).join(' - ')
      }
    },
    mounted: function() {
      this.getValue()
    }
  }
</script>