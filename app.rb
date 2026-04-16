require_relative 'config.rb'
require_relative 'models/genre.rb'
require_relative 'models/song.rb'
require_relative 'models/account.rb'

class App < Sinatra::Base

    setup_development_features(self)

    before do
        @current_page = ""
        @account = session[:current_account]
    end

    
    get '/' do
        @current_page = "Home"
        erb :"index"
    end

    get '/genres' do
        @current_page = "Genres"
        @genres = Genre.all
        erb :"genres/index"
    end

    get '/genres/:id' do | id |
        @current_page = "Viewing Genre"
        @genre = Genre.find_by_id(id)
        erb :"genres/view"
    end

    get '/songs' do
        @current_page = "Songs"
        @songs = Song.all
        erb :"songs/index"
    end

    get '/songs/new' do
        if @account == nil or @account["type"] == "user"
            #Create failed
            session[:error] = "401 Unauthorized - Wrong account permission"
            redirect '/error'
        end

        @current_page = "New Song"
        erb :"songs/new"  
    end

    post '/songs/new' do
    
        name = params[:name]
        id = @account["id"]

        if Song.find_by_name(name)
            #Create failed - name already exists
            session[:error] = "409 Conflict - Song name already exists"
            redirect '/error'
        end

        Song.create(name, id)
        redirect "/songs"
    end

    get '/songs/:id' do  | id |
        @current_page = "Viewing Song"
        @song = Song.find_by_id(id)
        erb :"songs/view"  
    end

    get '/songs/:id/update' do  | id |
        @current_page = "Update Song"
        @song = Song.find_by_id(id)

        if @account == nil or @account["id"] != @song["artist_id"]
            #Update failed
            session[:error] = "401 Unauthorized - Wrong account permission"
            redirect '/error'
        end

        erb :"songs/update"  
    end

    post '/songs/:id/update' do  | id |
        title = params[:title]
        Song.update(title,id)
        redirect "/songs"
    end


    post '/songs/:id/delete' do | id |
        Song.delete(id)
        redirect "/songs"
    end

    get '/accounts' do
        @current_page = "Manage account"
        erb :"accounts/manage"
    end

    post '/accounts/logout' do
        session[:current_account] = nil
        redirect '/accounts'
    end

    get '/accounts/login' do
        @current_page = "Login"
        erb :"accounts/login"
    end

    post '/accounts/login' do
        name = params[:name]
        plain_password = params[:password]
        account = Account.find(name)

        if !account
            #Login failed - no user
            session[:error] = "401 Unauthorized - Account does not exist"
            redirect '/error'
        end

        hashed_password = account["password"].to_s

        # Create a BCrypt object from the hashed password from db
        unhashed_password = BCrypt::Password.new(hashed_password)
        # Check if the plain password matches the hashed password from db
        if unhashed_password == plain_password
            #Login success - correct password
            session[:current_account] = account
            redirect '/accounts'
        else
            #Login failed - incorrect password
            session[:error] = "401 Unauthorized - Incorrect Password"
            redirect '/error'
        end
    end

    get '/accounts/register' do
        @current_page = "Register"
        erb :"accounts/register"
    end

    post '/accounts/register' do
        name = params[:name]
        plain_password = params[:password]
        type = params[:type]
        account = Account.find(name)

        hashed_password = BCrypt::Password.create(plain_password)

        if account
            #Register failed - name already exists
            session[:error] = "409 Conflict - Account name already exists"
            redirect '/error'            
        else
            #Register success - name not used
            Account.register(name, hashed_password, type)
            session[:current_account] = Account.find(name)
            redirect '/accounts'
        end
    end

    post '/accounts/:id/delete' do | id |
        Account.delete(id)
        session[:current_account] = nil
        redirect "/accounts"
    end

    get '/error' do
        @current_page = "Error"
        @error = session[:error]
        erb :"error"  
    end

    not_found do
        @current_page = "Error"
        @error = "404 Not Found"
        erb :"error"  
    end

end
