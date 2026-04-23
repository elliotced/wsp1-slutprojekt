class Song
  # Creates a new song with name and artist_id
  # 
  # @param name [String] name of the song
  # @param id [Integer] id of the account creating the song
  # @return [void]
  def self.create(name, id)
    db.execute("INSERT INTO songs (title, artist_id) VALUES (?, ?)", [name, id])
  end

  # Selects all songs and joins artist names with artist_id
  # 
  # @return [Array<Hash>] all songs
  def self.all()
    songs = db.execute('SELECT songs.*, accounts.name AS artist_name FROM songs JOIN accounts ON songs.artist_id = accounts.id')
    return songs
  end

  # Finds song with the name
  # 
  # @param name [String] name of the song
  # @return [Hash, nil] song matching the name, or nil if not found
  def self.find_by_name(name)
    song = db.execute('SELECT * FROM songs WHERE title = ?', name).first
    return song
  end

  # Finds song with the id
  # 
  # @param id [Integer] id of the song
  # @return [Hash, nil] song matching the id, or nil if not found
  def self.find_by_id(id)
    song = db.execute('SELECT * FROM songs WHERE id = ?', id).first
    return song
  end

  # Updates data of a song
  # 
  # @param title [String] new name of the song
  # @param id [Integer] id of the song being updated
  # @return [void]
  def self.update(title, id)
    db.execute('UPDATE songs SET title=? WHERE id=?', [title, id])
  end

  # Deletes the song with the id
  # 
  # @param id [Integer] id of the song
  # @return [void]
  def self.delete(id)
    db.execute('DELETE FROM songs WHERE id=?', id).first  
  end
end