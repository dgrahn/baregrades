class ApplicationController < ActionController::Base
	protect_from_forgery
	

	def rescue_with_handler(exception)
		if current_user and current_user.is_administrator?
			@exception = exception
		end

		render :template => "errors/500"
	end
	
	before_filter :require_login
	private
	def require_login
		unless current_user
			redirect_to login_url
		end
	end

	helper_method :current_user
	private
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
end