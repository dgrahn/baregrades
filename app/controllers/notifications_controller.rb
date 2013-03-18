class NotificationsController < ApplicationController
	#Sets up index page
	def index
		# Get all notifications
		@user_notifications = Notification.where(user_id: @current_user.id).order("created_at DESC")

		# Render layout
		render "index", layout:false
	end

	# Ajax notification destroy
	def destroy
		# Destroy notification
		notif = Notification.find(params[:id])
		notif.destroy
		
		# Render nothing because this is 
		render nothing: true
	end
end
