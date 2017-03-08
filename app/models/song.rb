class Song < ActiveRecord::Base
  has_many :generalplaylists
  has_many :counters
  belongs_to :artist

  validates :artist, presence: true

  def self.destroy_all
    songs = Song.all
    songs.each do |song|
      song.destroy
    end
  end

end
