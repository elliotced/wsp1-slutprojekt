require 'fileutils'
require 'rack'
require 'rackup'
require 'sinatra'
require 'sqlite3'
require 'awesome_print'
require 'debug'
require 'bcrypt'

ENV['RACK_ENV'] ||= 'development'

DB_NAME   = 'database.sqlite'
DB_FOLDER = 'db'
DB_PATH   = File.expand_path(File.join(__dir__, DB_FOLDER, DB_NAME))

FileUtils.mkdir_p(File.dirname(DB_PATH))

# database var
def db
  return @db if @db
  @db = SQLite3::Database.new('db/database.sqlite')
  @db.results_as_hash = true
  @db
end

# settings for webserver
def setup_development_features(app_class)
  if ENV['RACK_ENV'] == 'development'
    require 'sinatra/reloader'
    app_class.register Sinatra::Reloader
    
    if Dir.exist?(File.join(__dir__, 'models'))
      app_class.also_reload File.join(__dir__, 'models', '*.rb')
    end

    app_class.also_reload File.join(__dir__, 'config.rb')
    puts "♻️  Auto-reload aktiv (inklusive views och models)"

    enable :sessions
  end
end