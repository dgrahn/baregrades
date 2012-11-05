class UserMailer < ActionMailer::Base
	default :to => "admin@baregrades.com"
			
	
	def feedback(email, topic, description)
	
		mail(:to 		=> "admin@baregrades.com",
			 :cc 		=> ["jengel@cedarville.edu", "dgrahn@cedarville.edu", "mbrooker@cedarville.edu"],
			 :from 		=> email,
			 :subject 	=> topic,
			 :body 		=> description)
	end
end