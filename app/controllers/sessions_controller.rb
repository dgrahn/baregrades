class SessionsController < ApplicationController
	layout "login"
	skip_before_filter :require_login

	#Saves new session.
	def create
		user = User.authenticate(params[:username], params[:password])
		
		if user && user.enabled
			session[:user_id] = user.id

			LogsController.login(user)

			# TODO: Send to homepage
			redirect_to root_path, :flash => {:success => "Logged In"}
		elsif user
			flash.now[:error] = "Invalid Login. You must confirm your account through your email. If this problem persists email admin@baregrades.com"
			render "new"
		else
			flash.now[:error] = "Invalid Login."
			render "new"
		end
	end
	
	def swap
		if current_user.is_administrator?
			session[:user_id] = params[:id]	
			redirect_to root_path, :flash => {:sucess => "User Swapped!"}
		end
	end

	#Destroys session.
	def destroy
		# Can't user @current_user here for some reason
		if User.exists?(:id => session[:user_id])
			user = User.find(session[:user_id])

			LogsController.logout(user)
		end

		# Delete the session
		session[:user_id] = nil	
		
		# Display message
		flash.now[:success] = "Logged Out"
		render "new"
	end
end