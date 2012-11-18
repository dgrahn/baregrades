class UserMailerController < ApplicationController
	skip_before_filter :require_login, :only => [:forgotPassword, :resetPassword]
	
	# Redirects the user to the feedback form
	def feedback
		respond_to do |format|
			format.html
		end
	end # def feedback
	
	# Redirects the user to the forgotPassword form
	def forgotPassword
		respond_to do |format|
			format.html {render layout:"login"}
		end # respond_to
	end # def forgotPassword
	
	# Receives the Form Post, Delivers the email, and redirects the user
	def submitFeedback
		@email = params[:email]
		@topic = params[:topic]
		@description = params[:description]
		
		UserMailer.feedback(@email, @topic, @description).deliver
		respond_to do |format|
			format.html { redirect_to root_path, notice: "Feedback was sent successfully!" }
		end # respond_to
	end # def submitFeedback
	
	# Receives the Form Post, Delivers the email, and redirects the user
	def resetPassword
		user = User.find_by_email(params[:email])
		
		respond_to do |format|
			if user.blank?
				format.html { redirect_to root_path, notice: 'Invalid Email.'}
			else
				chars = ("a".."z").to_a + ("A".."Z").to_a
				password = chars[rand(chars.size-1)]
				chars += ("0".."9").to_a
				15.times do |i|
					password += chars[rand(chars.size-1)]
				end
				
				user.password = password
				user.password_confirmation = password
				
				if user.save && UserMailer.resetPassword(user.email, user.first_name, password).deliver
					format.html { redirect_to root_path, notice: 'Your password was reset.'}
				else
					format.html { redirect_to root_path, notice: 'There was a problem with resetting your password.'}
				end # if
			end # if
		end # respond_to
	end # def resetPassword
end # class UserMailerController
