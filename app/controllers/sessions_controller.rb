class SessionsController < ApplicationController
	layout "login"
	skip_before_filter :require_login

	def new
	end

	def create
		user = User.authenticate(params[:username], params[:password])

		if user
			session[:user_id] = user.id

			# TODO: Send to homepage
			redirect_to root_path, :flash => {:success => "Logged In"}
		else
			flash.now[:error] = "Invalid Login"
			render "new"
		end
	end

	def destroy
		session[:user_id] = nil
		
		flash.now[:success] = "Logged Out"
		render "new"
	end
end