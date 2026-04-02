class Song
  def self.create(name, id)
    db.execute("INSERT INTO songs (title, artist_id) VALUES (?, ?)", [name, id])
  end

  def self.all()
    songs = db.execute('SELECT songs.*, accounts.name AS artist_name FROM songs JOIN accounts ON songs.artist_id = accounts.id')
    return songs
  end

  def self.find_by_name(name)
    song = db.execute('SELECT * FROM songs WHERE id = ?', name).first
    return song
  end

  def self.find_by_id(id)
    song = db.execute('SELECT * FROM songs WHERE id = ?', id).first
    return song
  end

  def self.update(title, id)
    db.execute('UPDATE songs SET title=? WHERE id=?', [title, id])
  end

  def self.delete(id)
    db.execute('DELETE FROM songs WHERE id=?', id).first
  end
end