require_relative 'config.rb'
require_relative 'models/user.rb'

class App < Sinatra::Base

    setup_development_features(self)

    before do
        @current_page = ""
        @logged_in = !session[:user_id].nil?
    end

    
    get '/' do
        @current_page = "Home"
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
        username = params[:username]
        plain_password = params[:password]
        user = User.login(username)

        if !user
            session[:error] = "401 Unauthorized - User does not exist"
            redirect '/error'
        end

        db_id = user["id"].to_i
        hashed_password = user["password"].to_s

        # Create a BCrypt object from the hashed password from db
        unhashed_password = BCrypt::Password.new(hashed_password)
        # Check if the plain password matches the hashed password from db
        if unhashed_password == plain_password
            ap "/users/login : Logged in"
            session[:user_id] = db_id
            redirect '/'
        else
            session[:error] = "401 Unauthorized - Invalid Password"
            redirect '/error'
        end
    end

    get '/users/register' do
        @current_page = "Register"
        erb :"users/register"
    end

    post '/users/register' do
        username = params[:username]
        plain_password = params[:password]

        hashed_password = BCrypt::Password.create(plain_password)

        exists = User.register(username,hashed_password)

        if exists == true
            session[:error] = "409 Conflict - Invalid Password"
            redirect '/error'            
        else 
            redirect '/'
        end
    end

    get '/error' do
        @current_page = "Error"
        @error = session[:error]
        erb :"error"  
    end

end
