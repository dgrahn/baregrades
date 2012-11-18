class UserMailer < ActionMailer::Base
	default from: "admin@baregrades.com"
	
	def feedback(email, topic, description)
		mail(from: 		email,
			 to: 		"admin@baregrades.com",
			 cc: 		["jengel@cedarville.edu"],
			 subject: 	"[BareGrades Feedback] " + topic,
			 body: 		["From: " + email + " - " + description])
	end
	
	def resetPassword(email, name, password)
		@users_name = name
		@password = password
		
		mail(to: 		email,
			 from: 		"admin@baregrades.com",
			 subject: 	"[BareGrades] Reset Password")
	end
end