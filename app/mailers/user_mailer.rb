class UserMailer < ActionMailer::Base
	default :to => "admin@baregrades.com"
			
	
	def feedback(email, topic, description)
	
		mail(:to 		=> "jengel@cedarville.edu",
			 :from 		=> email,
			 :subject 	=> "[BareGrades Feedback] " + topic,
			 :body 		=> description)
	end
end