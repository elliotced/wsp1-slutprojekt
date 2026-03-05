require_relative 'config.rb'

class App < Sinatra::Base

    setup_development_features(self)

    before do
        @current_page = ""
        @logged_in = !session[:user_id].nil?
    end

    
    get '/' do
        @current_page = "Home"
        a = db.execute("select * from SONGS")
        p a
        erb :"index"
    end

    get '/users' do
        @current_page = "Users"
        erb :"users/user"
    end

    get '/users/login' do
        @current_page = "Login"
        erb :"users/login"
    end

    post '/users/login' do
        request_username = params[:username]
        request_plain_password = params[:password]
        user = db.execute("SELECT *
                FROM users
                WHERE username = ?",
                request_username).first

        unless user
            ap "/users/login : Invalid username."
            status 401
            redirect '/acces_denied'
        end

        db_id = user["id"].to_i
        db_password_hashed = user["password"].to_s

        # Create a BCrypt object from the hashed password from db
        bcrypt_db_password = BCrypt::Password.new(db_password_hashed)
        # Check if the plain password matches the hashed password from db
        if bcrypt_db_password == request_plain_password
            ap "/users/login : Logged in"
            session[:user_id] = db_id
            redirect '/'
        else
            ap "/users/login : Invalid password."
            status 401
            redirect '/acces_denied'
        end
    end

    get '/users/register' do
        @current_page = "Register"
        erb :"users/register"
    end

    post '/users/register' do
        
    end

    get '/acces_denied' do
        @current_page = "401"
        erb :"access_denied"
    end

end
