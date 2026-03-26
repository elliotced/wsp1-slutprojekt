class Song
  def self.index()
    songs = db.execute('SELECT * FROM songs')
    return songs
  end

  def self.create(name, mp3_path, artist_id)
    db.execute("INSERT INTO songs (name, mp3_path, artist_id) VALUES (?, ?, ?)", [name, mp3_path, artist_id])
  end
end