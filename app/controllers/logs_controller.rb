class LogsController < ApplicationController
	def new
		if @current_user
			self.user = @current_user
		end
	end
end