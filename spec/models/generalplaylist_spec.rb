# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generalplaylist do
  let(:artist_1) { FactoryBot.create :artist }
  let(:song_1) { FactoryBot.create :song, artist: artist_1 }
  let(:artist_2) { FactoryBot.create :artist }
  let(:song_2) { FactoryBot.create :song, artist: artist_2 }
  let(:radiostation) { FactoryBot.create :radiostation }
  let(:playlist_1) { FactoryBot.create :generalplaylist, :filled, song: song_1, artist: artist_1 }
  let(:playlist_2) { FactoryBot.create :generalplaylist, :filled, song: song_2, artist: artist_2, radiostation: radiostation }
  let(:playlist_3) { FactoryBot.create :generalplaylist, :filled, song: song_2, artist: artist_2, radiostation: radiostation }

  describe '#check_npo_radio' do
    context 'given an address and radiostation' do
      it 'creates a new playlist item' do
        address = 'https://www.npo3fm.nl/api/tracks'
        track_data = Generalplaylist.check_npo_radio(address)

        if track_data.is_a?(Array)
          expect(track_data).to be_an_instance_of(Array)
          expect(track_data.count).to eq 3
        else
          expect(track_data).to eq false
        end
      end
    end
  end

  describe '#check_talpa_radio' do
    context 'given an address and radiostation' do
      it 'creates an new playlist item' do
        address = 'https://graph.talparad.io/?query=%7B%0A%20%20getStation(profile%3A%20%22radio-brand-web%22%2C%20slug%3A%20%22sky-radio%22)%20%7B%0A%20%20%20%20title%0A%20%20%20%20playouts(profile%3A%20%22%22%2C%20limit%3A%2010)%20%7B%0A%20%20%20%20%20%20broadcastDate%0A%20%20%20%20%20%20track%20%7B%0A%20%20%20%20%20%20%20%20id%0A%20%20%20%20%20%20%20%20title%0A%20%20%20%20%20%20%20%20artistName%0A%20%20%20%20%20%20%20%20isrc%0A%20%20%20%20%20%20%20%20images%20%7B%0A%20%20%20%20%20%20%20%20%20%20type%0A%20%20%20%20%20%20%20%20%20%20uri%0A%20%20%20%20%20%20%20%20%20%20__typename%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20__typename%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20__typename%0A%20%20%20%20%7D%0A%20%20%20%20__typename%0A%20%20%7D%0A%7D%0A&variables=%7B%7D'
        track_data = Generalplaylist.check_talpa_radio(address)

        if track_data.is_a?(Array)
          expect(track_data).to be_an_instance_of(Array)
          expect(track_data.count).to eq 3
        else
          expect(track_data).to eq false
        end
      end
    end
  end

  describe '#radio_1_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_npo_radio).and_return(["Chef's Special", 'Mayby This Is Love', '19:51'])
      expect {
        Generalplaylist.radio_1_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_2_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_npo_radio).and_return(['Goldkimono', 'To Tomorrow', '20:13'])
      expect {
        Generalplaylist.radio_2_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_3fm_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_npo_radio).and_return(['Haim', 'The Steps', '19:16'])
      expect {
        Generalplaylist.radio_3fm_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_4_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_npo_radio).and_return(['Cappella Amsterdam', 'O mors quam amara', '17:20'])
      expect {
        Generalplaylist.radio_4_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_5_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_npo_radio).and_return(['Fleetwood Mac', 'Everywhere', '19:05'])
      expect {
        Generalplaylist.radio_5_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#sky_radio_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_talpa_radio).and_return(['Billy Ocean', 'When The Going Gets Tough', '13:17'])
      expect {
        Generalplaylist.sky_radio_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_veronica_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_talpa_radio).and_return(['Earth, Wind & Fire', "Let's Groove", '20:16'])
      expect {
        Generalplaylist.radio_veronica_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_538_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_talpa_radio).and_return(['Steve Lucas', 'Love Letters', '16:44'])
      expect {
        Generalplaylist.radio_538_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#radio_10_check' do
    it 'creates a new playlist item' do
      allow(Generalplaylist).to receive(:check_talpa_radio).and_return(['The Farm', 'All Together Now', '13:39'])
      expect {
        Generalplaylist.radio_10_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#q_music_check' do
    it 'creates a new playlist item' do
      expect {
        Generalplaylist.q_music_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#sublime_fm_check' do
    it 'creates a new playlist item' do
      expect {
        Generalplaylist.sublime_fm_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#grootnieuws_radio_check' do
    it 'creates a new playlist item' do
      expect {
        Generalplaylist.grootnieuws_radio_check
      }.to change(Generalplaylist, :count).by(1)
    end
  end

  describe '#title_check' do
    context 'a title with more then 4 digits' do
      it 'returns false' do
        expect(Generalplaylist.title_check('test 1234')).to eq false
      end
    end

    context 'a title with a forward slash' do
      it 'returns false' do
        expect(Generalplaylist.title_check('test / go ')).to eq false
      end
    end

    context 'a title with 2 single qoutes' do
      it 'returns false' do
        expect(Generalplaylist.title_check("test''s")).to eq false
      end
    end

    context 'a titlle that has reklame or reclame' do
      it 'returns false' do
        expect(Generalplaylist.title_check('test reclame')).to eq false
      end
    end

    context 'a title that has more then two dots' do
      it 'returns false' do
        expect(Generalplaylist.title_check('test..test')).to eq false
      end
    end

    context 'any other title' do
      it 'returns true' do
        expect(Generalplaylist.title_check('Liquid Spirit')).to eq true
      end
    end
  end

  describe '#search' do
    before do
      playlist_1
      playlist_2
      playlist_3
    end
    context 'with search term params' do
      it 'returns the playlists artist name or song title that matches the search terms' do
        expected = [playlist_1]

        expect(Generalplaylist.search({ search_term: song_1.fullname })).to eq expected
      end
    end

    context 'with radiostations params' do
      it 'returns the playlist played on the radiostation' do
        expect(Generalplaylist.search({ radiostation_id: radiostation.id })).to include playlist_2, playlist_3
      end
    end

    context 'with no params' do
      it 'returns all the playlists' do
        expect(Generalplaylist.search({})).to include playlist_1, playlist_2, playlist_3
      end
    end
  end
end