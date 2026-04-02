require_relative '../config.rb'

class Seeder
  
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS accounts')
    db.execute('DROP TABLE IF EXISTS genres')
    db.execute('DROP TABLE IF EXISTS genres_songs')
    db.execute('DROP TABLE IF EXISTS songs')
  end

  def self.create_tables
    db.execute('CREATE TABLE accounts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                password TEXT NOT NULL,
                type TEXT NOT NULL)')

    db.execute('CREATE TABLE genres (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                png_path TEXT)')

    db.execute('CREATE TABLE genres_songs (
                genre_id INTEGER,
                song_id INTEGER)')

    db.execute('CREATE TABLE songs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                artist_id INT)')
  end

  def self.populate_tables
    db.execute('INSERT INTO accounts (name, password, type) VALUES (?, ?, ?)', ["ola", BCrypt::Password.create("123"), "admin"])
  end
end


Seeder.seed!