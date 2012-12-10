class ApplicationController < ActionController::Base
	protect_from_forgery
	
	def rescue_with_handler(exception)
		if current_user #and current_user.is_administrator?
			return
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
	
	before_filter :get_theme
	private
	def get_theme
		if @current_user and @current_user.theme
			@current_theme = @current_user.theme.css_class
		else
			@current_theme = "pond"
		end
	end
end