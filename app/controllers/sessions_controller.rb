class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.authenticate(params[:username], params[:password])

		if user
			session[:user_id] = user.id

			# TODO: Send to homepage
			flash.now[:success] = "Logged In"
			redirect_to users_path, :notice => "Logged In"
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