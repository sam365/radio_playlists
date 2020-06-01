# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Song do
  let(:artist_1) { FactoryBot.create :artist }
  let(:song_1) { FactoryBot.create :song, artist: artist_1 }
  let(:artist_2) { FactoryBot.create :artist }
  let(:song_2) { FactoryBot.create :song, artist: artist_2 }
  let(:radiostation) { FactoryBot.create :radiostation }
  let(:playlist_1) { FactoryBot.create :generalplaylist, :filled, song: song_1, artist: artist_1 }
  let(:playlist_2) { FactoryBot.create :generalplaylist, :filled, song: song_2, artist: artist_2, radiostation: radiostation }
  let(:playlist_3) { FactoryBot.create :generalplaylist, :filled, song: song_2, artist: artist_2, radiostation: radiostation }

  before do
    playlist_1
    playlist_2
    playlist_3
  end

  describe '#search' do
    context 'with search term params present' do
      it 'only returns the songs matching the search term' do
        results = Song.search({ search_term: song_1.fullname })

        expect(results).to eq [playlist_1]
      end
    end

    context 'with radiostation_id params present' do
      it 'only returns the songs played on the radiostation' do
        results = Song.search({ radiostation_id: radiostation.id })

        expect(results).to include playlist_2, playlist_3
      end
    end
  end

  describe '#group_and_count' do
    it 'groups and counts the songs' do
      results = Song.group_and_count(Generalplaylist.all)

      expect(results).to eq [[song_2.id, 2], [song_1.id, 1]]
    end
  end
end
