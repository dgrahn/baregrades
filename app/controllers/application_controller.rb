class ApplicationController < ActionController::Base
	
	protect_from_forgery
	# Displays exception if admin and error page if not.
	# @param exception [Exception] The exception thrown.
	def rescue_with_handler(exception)
		if current_user and current_user.is_administrator?
			return
			@exception = exception
		end
		
		if current_user
			render template: "errors/500"
		else
			render template: "errors/500", layout:"login"
		end
	end
	
	before_filter :require_login
	private
	#Redirects to login url unless user is logged in.
	def require_login
		unless current_user
			redirect_to login_url
		end
	end

	helper_method :current_user
	private
	#Assigns @current_user variable.
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	
	before_filter :get_theme
	private
	#Gets the current user's theme.
	def get_theme
		if @current_user and @current_user.theme
			@current_theme = @current_user.theme.css_class
		else
			@current_theme = "pond"
		end
	end
end