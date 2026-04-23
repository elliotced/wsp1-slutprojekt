class Genre
  # Selects all genres
  # 
  # @return [Array<Hash>] all genres in the database
  def self.all()
    genres = db.execute('SELECT * FROM genres')
    return genres
  end

  # Finds the genre with the id
  # 
  # @param id [Integer] id of the genre
  # @return [Hash, nil] genre matching the id, or nil if not found
  def self.find_by_id(id)
    genre = db.execute('SELECT * FROM genres WHERE id = ?', id).first
    return genre
  end

  # Finds all songs connected with the id of the genre using the genre_songs table
  # 
  # @param id [Integer] id of the genre
  # @return [Array<Hash>] all songs matching the id of the genre
  def self.find_songs_by_genre_id(id)
    songs = db.execute('SELECT songs.* FROM songs
                        INNER JOIN genres_songs ON songs.id = genres_songs.song_id
                        WHERE genres_songs.genre_id = ?', id)
    return songs
  end
end