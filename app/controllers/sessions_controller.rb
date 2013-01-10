class SessionsController < ApplicationController
	layout "login"
	skip_before_filter :require_login

	def new
	end

	def create
		user = User.authenticate(params[:username], params[:password])
		
		if user && user.enabled
			session[:user_id] = user.id
			
			# Add log
			log = Log.new
			log.user = user
			log.comments = "#{user.name} logged in."
			log.save

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

	def destroy
		session[:user_id] = nil
		
		# Add log
		log = Log.new
		log.user = user
		log.comments = "#{user.name} logged out."
		log.save
		
		flash.now[:success] = "Logged Out"
		render "new"
	end
end