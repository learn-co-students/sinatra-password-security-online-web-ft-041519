require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do #------renders an index.erb file with links to signup or login.
		erb :index
	end

	get "/signup" do #------renders a form to create a new user. The form includes fields for username and password.
		erb :signup
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password]) #make a new instance of our user class with a username and password from params
		if user.save
		    redirect "/login"
		  else
		    redirect "/failure"
		  end
	end

	get "/login" do #------renders a form for logging in.
		erb :login
	end

	post "/login" do
		user = User.find_by(:username => params[:username]) #------find user by looking at username hash and assign it to var "user"
		if user && user.authenticate(params[:password]) 		#------ensure that we have a User AND that that User is authenticated
			session[:user_id] = user.id #------If the user authenticates, we'll set the session[:user_id] and
    	redirect "/success" 				#------ redirect to the /success route
  	else
    	redirect "/failure" 				#------otherwise, we'll redirect to the /failure route so our user can try again.
  	end
	end

	get "/success" do #------renders a success.erb page, which should be displayed once a user successfully logs in.
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do #------renders a failure.erb page. This will be accessed if there is an error logging in or signing up.
		erb :failure
	end

	get "/logout" do 	#------clears the session data and redirects to the homepage.
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
