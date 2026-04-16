class Genre
  def self.all()
    genres = db.execute('SELECT * FROM genres')
    return genres
  end

  def self.find_by_id(id)
    genre = db.execute('SELECT * FROM genres WHERE id = ?', id).first
    return genre
  end
end