require 'sqlite3'
require_relative '../config'
require 'bcrypt'

class Seeder
  
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS artists')
    db.execute('DROP TABLE IF EXISTS artist_genres')
    db.execute('DROP TABLE IF EXISTS albums')
    db.execute('DROP TABLE IF EXISTS album_genres')
    db.execute('DROP TABLE IF EXISTS songs')
    db.execute('DROP TABLE IF EXISTS song_genres')
    db.execute('DROP TABLE IF EXISTS genres')
  end

  def self.create_tables
    db.execute('CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password TEXT NOT NULL)')

    db.execute('CREATE TABLE artists (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                description TEXT,
                png_path TEXT)')

    db.execute('CREATE TABLE artist_genres (
                genre_id INTEGER,
                artist_id INTEGER)')

    db.execute('CREATE TABLE albums (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                png_path TEXT,
                artist_id INTEGER)')

    db.execute('CREATE TABLE album_genres (
                genre_id INTEGER,
                album_id INTEGER)')

    db.execute('CREATE TABLE songs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                mp3_path TEXT,
                artist_id INTEGER,
                album_id INTEGER)')

    db.execute('CREATE TABLE song_genres (
                genre_id INTEGER,
                song_id INTEGER)')

    db.execute('CREATE TABLE genres (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                png_path TEXT)')
  end

  def self.populate_tables
    password_hashed = BCrypt::Password.create("123")
    p "Storing hashed password (#{password_hashed}) to DB. Clear text password (123) never saved."
    db.execute('INSERT INTO users (username, password) VALUES (?, ?)', ["ola", password_hashed])

    db.execute('INSERT INTO artists (name, description) VALUES ("Tame Impala", "Kevin parker is from Australia.")')
    db.execute('INSERT INTO songs (name, mp3_path, artist_id) VALUES ("Borderline", "songs/borderline.mp3", 1)')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/database.sqlite')
    @db.results_as_hash = true
    @db
  end
end


Seeder.seed!