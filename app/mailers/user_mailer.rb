class UserMailer < ActionMailer::Base
	default from: "admin@baregrades.com"
	
	def feedback(email, topic, description)
		mail(reply_to: 		email,
			 to: 		"admin@baregrades.com",
			 cc: 		["jengel@cedarville.edu", "dgrahn@cedarville.edu", "mbrooker@cedarville.edu"],
			 subject: 	"[BareGrades Feedback] " + topic,
			 body: 		description)
	end
	
	def resetPassword(email, name, password)
		@users_name = name
		@password = password
		
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