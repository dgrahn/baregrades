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
				format.html { redirect_to login_path, notice: 'No user found for that email.'}
				
			else
				chars = ("a".."z").to_a + ("A".."Z").to_a
				password = chars[rand(chars.size-1)]
				chars += ("0".."9").to_a
				15.times do |i|
					password += chars[rand(chars.size-1)]
				end
				
				oldPass = user.password
				user.password = password
				user.password_confirmation = password
				
				if user.save
					if UserMailer.resetPassword(user.email, user.first_name, password).deliver
						format.html {redirect_to login_path, notice: "Your password was reset. Checke da email."}
					else
						user.password = oldPass
						user.password_confirmation = oldPass
						user.save
						format.html {redirect_to login_path, notice: "There was a problem delivering the password to "}
					end
				else
					format.html {redirect_to login_path, notice: "There was a problem with reseting your password. I am really, seriously sorry."}
					
				end # if
			end # if
		end # respond_to
	end # def resetPassword
end # class UserMailerController
