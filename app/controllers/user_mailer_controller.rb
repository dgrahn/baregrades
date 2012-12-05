class UserMailerController < ApplicationController
	skip_before_filter :require_login, :only => [:forgotPassword, :resetPassword]
	
	# Redirects the user to the feedback form
	def feedback
		@user = @current_user

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
		
		begin
			UserMailer.feedback(@email, @topic, @description).deliver
		rescue Net::SMTPFatalError # Mailer delivery error
			@email = "admin@baregrades.com"
			UserMailer.feedback(@email, @topic, @description).deliver
		end
			
		respond_to do |format|
			format.html { redirect_to root_path, notice: "Feedback was sent successfully!" }
		end # respond_to
	end # def submitFeedback
	
	# Receives the Form Post, Delivers the email, and redirects the user
	def resetPassword
		user = User.find_by_email(params[:email])
		
		respond_to do |format|
			if user.blank?
				# No user for the given email
				format.html { redirect_to login_path, notice: 'No user found for that email.'}
				
			else
				# Generate a random password
				chars = ("a".."z").to_a + ("A".."Z").to_a
				password = chars[rand(chars.size-1)]
				chars += ("0".."9").to_a
				15.times do |i|
					password += chars[rand(chars.size-1)]
				end
				
				# Change the password
				oldPass = user.password # Save the old password in case of error
				user.password = password
				user.password_confirmation = password
				
				if user.save
					# Password saved correctly
					begin # Try catch block for mail delivery error
						UserMailer.resetPassword(user.email, user.first_name, password).deliver # Send the email
						
						# Email was successfully delivered
						format.html {redirect_to login_path, notice: "Your password was reset. Checke da email."}
						
					rescue Net::SMTPFatalError # Mailer delivery error
						# Reset to the old password
						user.password = oldPass
						user.password_confirmation = oldPass
						user.save
						
						# Problem delivering the email
						format.html {redirect_to login_path, notice: "There was a problem delivering the password to " + user.email}
					end	# begin
				else
					# Problem saving the password
					format.html {redirect_to login_path, notice: "There was a problem with reseting your password. I am really, seriously sorry."}
				end # if
			end # if
		end # respond_to
	end # def resetPassword
end # class UserMailerController
