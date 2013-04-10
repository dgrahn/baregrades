class UserMailer < ActionMailer::Base
	default from: "admin@baregrades.com"
	
	def feedback(email, topic, description)
		mail(reply_to: 		email,
			 to: 		"admin@baregrades.com",
			 cc: 		["jengel@cedarville.edu", "dgrahn@cedarville.edu", "mbrooker@cedarville.edu"],
			 subject: 	"[BareGrades Feedback] " + topic,
			 body: 		["From: " + email + " - " + description])
	end
	
	def resetPassword(email, user, password)
		@users_name = user.first_name
		@password = password
		@username = user.username
		
		mail(to: 		email,
			 from: 		"admin@baregrades.com",
			 subject: 	"[BareGrades] Reset Password")
	end
	
	def registration_confirmation(user)
		@user = user
		
		mail(to: 		@user.email,
			 from:		"admin@baregrades.com",
			 subject: 	"[BareGrades] Registration Confirmation")
	end
end